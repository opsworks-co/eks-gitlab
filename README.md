# Documentation

## Description and Architecture

This module was created to simplify deploying Gitlab into the EKS with storage on AWS S3, AWS Aurora for PostreSQL, and AWS ElastiCache Redis.

<p align="center">
  <img src="https://raw.githubusercontent.com/opsworks-co/eks-gitlab/master/.github/images/diagram.svg" alt="Architectural diagram" width="100%">
</p>

In the above diagram, you can see the components and their relations (PostgreSQL and Redis are not deployed with this module).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                        | Version |
| --------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform)    | >= 1.0  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                      | 5.36.0  |
| <a name="requirement_helm"></a> [helm](#requirement_helm)                   | 2.11.0  |
| <a name="requirement_kubectl"></a> [kubectl](#requirement_kubectl)          | ~> 2.0  |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement_kubernetes) | >= 2.20 |
| <a name="requirement_time"></a> [time](#requirement_time)                   | >= 0.9  |

## Providers

| Name                                                                  | Version |
| --------------------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                      | 5.36.0  |
| <a name="provider_helm"></a> [helm](#provider_helm)                   | 2.11.0  |
| <a name="provider_kubernetes"></a> [kubernetes](#provider_kubernetes) | 2.25.2  |

## Modules

| Name                                                                 | Source                                                              | Version |
| -------------------------------------------------------------------- | ------------------------------------------------------------------- | ------- |
| <a name="module_gitlab_role"></a> [gitlab_role](#module_gitlab_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | v5.34.0 |
| <a name="module_s3_bucket"></a> [s3_bucket](#module_s3_bucket)       | terraform-aws-modules/s3-bucket/aws                                 | 4.1.0   |

## Resources

| Name                                                                                                                                           | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [helm_release.gitlab](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release)                                    | resource    |
| [kubernetes_namespace.gitlab](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace)                    | resource    |
| [kubernetes_secret.gitlab_omniauth_providers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret)       | resource    |
| [kubernetes_secret.gitlab_rails_storage](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret)            | resource    |
| [kubernetes_secret.postgres](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret)                        | resource    |
| [kubernetes_secret.redis](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret)                           | resource    |
| [kubernetes_secret.smtp](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret)                            | resource    |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/5.36.0/docs/data-sources/eks_cluster)                              | data source |
| [aws_iam_policy_document.s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/5.36.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.36.0/docs/data-sources/region)                                    | data source |

## Inputs

| Name                                                                                          | Description                                                                                 | Type          | Default    | Required |
| --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ------------- | ---------- | :------: |
| <a name="input_cluster_name"></a> [cluster_name](#input_cluster_name)                         | EKS cluster name where you want to deploy the release                                       | `string`      | n/a        |   yes    |
| <a name="input_database_password"></a> [database_password](#input_database_password)          | Password to access PostgreSQL database                                                      | `string`      | n/a        |   yes    |
| <a name="input_gitlab_chart_version"></a> [gitlab_chart_version](#input_gitlab_chart_version) | Version of the gitlab chart                                                                 | `string`      | `"7.8.1"`  |    no    |
| <a name="input_omniauth_providers"></a> [omniauth_providers](#input_omniauth_providers)       | OmniAuth providers                                                                          | `map(string)` | `{}`       |    no    |
| <a name="input_redis_password"></a> [redis_password](#input_redis_password)                   | Password to access Redis database                                                           | `string`      | n/a        |   yes    |
| <a name="input_release_name"></a> [release_name](#input_release_name)                         | This is the name of the release which also used as a prefix or suffix for the resources     | `string`      | `"gitlab"` |    no    |
| <a name="input_release_namespace"></a> [release_namespace](#input_release_namespace)          | Namespace name where you want to deploy the release. If empty, `release_name` will be used. | `string`      | `""`       |    no    |
| <a name="input_smtp_password"></a> [smtp_password](#input_smtp_password)                      | SMTP Password                                                                               | `string`      | `""`       |    no    |
| <a name="input_smtp_user"></a> [smtp_user](#input_smtp_user)                                  | SMTP Username                                                                               | `string`      | `""`       |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                 | A map of tags to add to all resources                                                       | `map(string)` | `{}`       |    no    |
| <a name="input_values"></a> [values](#input_values)                                           | Custom values.yaml file for the Helm chart                                                  | `any`         | `[]`       |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
