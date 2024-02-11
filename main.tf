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

resource "aws_s3_bucket" "gitlab" {
  for_each = local.buckets_list

  bucket = each.value
  tags   = var.tags
}

resource "aws_s3_bucket_ownership_controls" "gitlab" {
  for_each = local.buckets_list
  bucket   = aws_s3_bucket.gitlab[each.key].id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "gitlab" {
  for_each   = local.buckets_list
  depends_on = [aws_s3_bucket_ownership_controls.gitlab]

  bucket = aws_s3_bucket.gitlab[each.key].id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "gitlab" {
  for_each = local.buckets_list
  bucket   = aws_s3_bucket.gitlab[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "helm_release" "gitlab" {
  namespace        = local.release_namespace
  create_namespace = true

  name       = var.release_name
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"
  version    = var.gitlab_chart_version
  values     = var.values

  set {
    name  = "global.smtp.user_name"
    value = var.smtp_user
  }

  depends_on = [
    kubernetes_secret.postgres,
    kubernetes_secret.redis,
    kubernetes_secret.gitlab_rails_storage
  ]
}
