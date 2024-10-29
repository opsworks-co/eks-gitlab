variable "release_name" {
  description = "This is the name of the release which also used as a prefix or suffix for the resources"
  type        = string
  default     = "gitlab"
}

variable "release_namespace" {
  description = "Namespace name where you want to deploy the release. If empty, `release_name` will be used."
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "EKS cluster name where you want to deploy the release"
  type        = string
}

variable "values" {
  description = "Custom values.yaml file for the Helm chart"
  type        = any
  default     = []
}

variable "gitlab_chart_version" {
  description = "Version of the gitlab chart"
  type        = string
  default     = "7.8.1"
}

variable "database_password" {
  type        = string
  description = "Password to access PostgreSQL database"
  sensitive   = true
}

variable "redis_password" {
  type        = string
  description = "Password to access Redis database"
  sensitive   = true
}

variable "smtp_user" {
  type        = string
  default     = ""
  description = "SMTP Username"
}

variable "smtp_password" {
  type        = string
  default     = ""
  description = "SMTP Password"
  sensitive   = true
}

variable "omniauth_providers" {
  description = "OmniAuth providers"
  type        = map(string)
  default     = {}
}

variable "ldap-password" {
  description = "LDAP password"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
