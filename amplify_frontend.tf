resource "aws_amplify_app" "main" {
  name                        = local.frontend_repository_name
  enable_auto_branch_creation = true
  enable_branch_auto_deletion = true
  enable_branch_auto_build    = true

  repository = local.frontend_repository_url
  platform   = "WEB"

  auto_branch_creation_patterns = ["*/**"]

  auto_branch_creation_config {
    basic_auth_credentials = local.basic_auth_credentials
    build_spec             = local.build_spec
    enable_auto_build      = true
    enable_basic_auth      = true
    environment_variables = {
      REACT_APP_STAGE = "DEV"
    }
    stage = "DEVELOPMENT"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|wav|png|txt|svg|woff|woff2|ttf|map|json|otf)$)([^.]+$)/>"
    target = "/index.html"
    status = "200"
  }

  build_spec = local.build_spec

  access_token = "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"
}

resource "aws_amplify_branch" "main" {
  app_id                      = aws_amplify_app.main.id
  branch_name                 = "main"
  enable_auto_build           = true
  enable_basic_auth           = true
  basic_auth_credentials      = local.basic_auth_credentials
  enable_pull_request_preview = true
  environment_variables = {
    REACT_APP_STAGE = "DEV"
  }
  stage = "DEVELOPMENT"
}

# TODO: You have to manually enable subdomain auto-detection when creating this resource
resource "aws_amplify_domain_association" "root" {
  app_id      = aws_amplify_app.main.id
  domain_name = local.root_domain

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }

  lifecycle {
    ignore_changes = [sub_domain]
  }
}
