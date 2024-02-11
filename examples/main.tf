locals {
  saml_google_provider = <<EOF
name: saml
label: 'G Suite'
args:
  assertion_consumer_service_url: 'https://gitlab.example.com/users/auth/saml/callback'
  idp_cert_fingerprint: '00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00'
  idp_sso_target_url: 'https://accounts.google.com/o/saml2/idp?idpid=aabbccdde'
  issuer: 'https://gitlab.example.com'
  name_identifier_format: 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress'
  attribute_statements: {
    email: [
      'emailAddress'
    ]
  }
EOF
}

module "gitlab" {
  source = "../"

  cluster_name         = "my-eks-cluster"
  release_name         = "gitlab"
  gitlab_chart_version = "7.8.1"

  database_password = "database_password"
  redis_password    = "redis_password"
  smtp_user         = "postfix"
  smtp_password     = "smtp_password"
  omniauth_providers = {
    "gitlab-omniauth-saml" = local.saml_google_provider
  }

  values = [
    templatefile("values.yaml", {
      database_host     = "gitlab.xxxxxxxxxxxx.eu-central-1.rds.amazonaws.com"
      database_port     = "5432"
      database_username = "postgres"
      redis_host        = "master.gitlab.xxxxxx.euc1.cache.amazonaws.com"
      redis_port        = "6379"
      release_name      = "gitlab"
      bucket_prefix     = "gitlab-mycompany"
      domain            = "example.com"
      smtp_address      = "smtp.gmail.com"
    })
  ]

  tags = {}
}
