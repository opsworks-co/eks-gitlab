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

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gitlab"></a> [gitlab](#module\_gitlab) | ../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
