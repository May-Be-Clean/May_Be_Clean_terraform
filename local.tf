locals {
  common_project_name = "yourssu-project"
  project_name        = "yourssu-project" # FIXME

  root_domain     = "yourssu-inviter.link"
  frontend_domain = "web.${local.root_domain}" # FIXME
  backend_domain  = "api.${local.frontend_domain}" # FIXME

  # Amplify for frontend
  frontend_repository_name = "TodayTodolist" # FIXME
  frontend_repository_url  = "https://github.com/TodayTodolist/TodayTodolist"
  basic_auth_credentials   = base64encode("seddong:seddong!")
  build_spec               = file("amplify_build_spec.yml")
}
