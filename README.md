# Documentation

## Description and Architecture

This module was created to simplify deploying Gitlab into the EKS with storage on AWS S3, AWS Aurora for PostreSQL, and AWS ElastiCache Redis.

<p align="center">
  <img src="https://raw.githubusercontent.com/opsworks-co/eks-gitlab/master/.github/images/diagram.svg" alt="Architectural diagram" width="100%">
</p>

In the above diagram, you can see the components and their relations (PostgreSQL and Redis are not deployed with this module).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.36.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.20 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.36.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.33.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gitlab_role"></a> [gitlab\_role](#module\_gitlab\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | v5.34.0 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 4.1.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.gitlab](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubernetes_namespace.gitlab](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.gitlab_omniauth_providers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.gitlab_rails_storage](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.ldap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.postgres](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.redis](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.smtp](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/5.36.0/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/5.36.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.36.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets_lifecycles"></a> [buckets\_lifecycles](#input\_buckets\_lifecycles) | Lifecycle rules for buckets | `map(any)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name where you want to deploy the release | `string` | n/a | yes |
| <a name="input_database_password"></a> [database\_password](#input\_database\_password) | Password to access PostgreSQL database | `string` | n/a | yes |
| <a name="input_gitlab_chart_version"></a> [gitlab\_chart\_version](#input\_gitlab\_chart\_version) | Version of the gitlab chart | `string` | `"7.8.1"` | no |
| <a name="input_ldap_password"></a> [ldap\_password](#input\_ldap\_password) | LDAP password | `string` | `""` | no |
| <a name="input_omniauth_providers"></a> [omniauth\_providers](#input\_omniauth\_providers) | OmniAuth providers | `map(string)` | `{}` | no |
| <a name="input_redis_password"></a> [redis\_password](#input\_redis\_password) | Password to access Redis database | `string` | n/a | yes |
| <a name="input_release_max_history"></a> [release\_max\_history](#input\_release\_max\_history) | Maximum saved revisions per release | `number` | `10` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | This is the name of the release which also used as a prefix or suffix for the resources | `string` | `"gitlab"` | no |
| <a name="input_release_namespace"></a> [release\_namespace](#input\_release\_namespace) | Namespace name where you want to deploy the release. If empty, `release_name` will be used. | `string` | `""` | no |
| <a name="input_smtp_password"></a> [smtp\_password](#input\_smtp\_password) | SMTP Password | `string` | `""` | no |
| <a name="input_smtp_user"></a> [smtp\_user](#input\_smtp\_user) | SMTP Username | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_values"></a> [values](#input\_values) | Custom values.yaml file for the Helm chart | `any` | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
