resource "aws_secretsmanager_secret" "database" {
  name = "${var.project_name}/database/primary/${var.environment}"
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.database.id
  secret_string = jsonencode({
    engine   = var.database_engine
    dbname   = var.database_dbname
    host     = module.database_primary.cluster_endpoint
    port     = module.database_primary.cluster_port
    username = module.database_primary.cluster_master_username
    password = module.database_primary.cluster_master_password
  })
}
