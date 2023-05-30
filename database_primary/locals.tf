locals {
  is_main     = var.environment == "main"
  name_prefix = "${var.project_name}-${var.environment}-database-primary"
}
