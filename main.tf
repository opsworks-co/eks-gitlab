locals {
  release_namespace = coalesce(var.release_namespace, var.release_name)
}

data "aws_region" "current" {}

resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = local.release_namespace
  }
}

resource "kubernetes_secret" "postgres" {
  metadata {
    name      = "${var.release_name}-postgresql-password"
    namespace = local.release_namespace
  }

  data = {
    postgresql-password = var.database_password
    #We need below if we are going to deploy PostgreSQL next to the Gitlab in the EKS
    #not as RDS for PostgreSQL
    postgresql-postgres-password = var.database_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "redis" {
  metadata {
    name      = "${var.release_name}-redis-password"
    namespace = local.release_namespace
  }

  data = {
    secret = var.redis_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "smtp" {
  #count = local.values.global.smtp.authentication == "false" ? 0 : 1

  metadata {
    name      = try(local.values.global.smtp.password.secret, "${var.release_name}-smtp-password")
    namespace = local.release_namespace
  }

  data = {
    password = var.smtp_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "gitlab_rails_storage" {
  metadata {
    name      = "${var.release_name}-rails-storage"
    namespace = local.release_namespace
  }

  data = {
    connection = <<EOF
provider: AWS
region: ${data.aws_region.current.name}
use_iam_profile: true
EOF
    config     = <<EOF
[default]
bucket_location = ${data.aws_region.current.name}
multipart_chunk_size_mb = 128
EOF
  }

  type = "Opaque"
}

resource "kubernetes_secret" "gitlab_omniauth_providers" {
  for_each = local.omniauth_providers
  metadata {
    name      = each.value
    namespace = local.release_namespace
  }

  data = {
    provider = var.omniauth_providers[each.value]
  }

  type = "Opaque"
}

resource "kubernetes_secret" "ldap" {
  count = lookup(local.values.global.appConfig, "ldap", []) == [] ? 0 : 1
  metadata {
    name      = "${var.release_name}-ldap-password"
    namespace = local.release_namespace
  }

  data = {
    secret = var.ldap-password
  }

  type = "Opaque"
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  for_each = local.buckets_list

  statement {
    sid    = "AllowListForGitlabRole"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [module.gitlab_role.iam_role_arn]
    }
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${each.value}"]
  }

  statement {
    sid    = "AllowGetPutForGitlabRole"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [module.gitlab_role.iam_role_arn]
    }
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["arn:aws:s3:::${each.value}/*"]
  }
}

module "s3_bucket" {
  for_each = local.buckets_list
  source   = "terraform-aws-modules/s3-bucket/aws"
  version  = "4.1.0"

  bucket        = each.value
  acl           = null
  force_destroy = false

  versioning = {
    enabled = false
  }

  policy        = data.aws_iam_policy_document.s3_bucket_policy[each.key].json
  attach_policy = true

  attach_deny_insecure_transport_policy = true
  block_public_acls                     = true
  block_public_policy                   = true
  ignore_public_acls                    = true
  restrict_public_buckets               = true

  tags = var.tags
}

resource "helm_release" "gitlab" {
  namespace        = local.release_namespace
  create_namespace = true

  name        = var.release_name
  repository  = "https://charts.gitlab.io/"
  chart       = "gitlab"
  max_history = var.release_max_history
  version     = var.gitlab_chart_version
  values      = var.values

  set {
    name  = "global.smtp.user_name"
    value = var.smtp_user
  }

  set {
    name  = "global.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.gitlab_role.iam_role_arn
  }

  depends_on = [
    kubernetes_secret.postgres,
    kubernetes_secret.redis,
    kubernetes_secret.gitlab_rails_storage,
    module.gitlab_role
  ]
}

module "gitlab_role" {
  source                         = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                        = "v5.34.0"
  create_role                    = true
  allow_self_assume_role         = false
  role_description               = "Gitlab Role to access S3"
  role_name                      = "${var.release_name}-access-s3"
  provider_url                   = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
  oidc_subjects_with_wildcards   = ["system:serviceaccount:${local.release_namespace}:gitlab*"]
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  tags                           = var.tags
}
