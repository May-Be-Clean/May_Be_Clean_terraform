data "aws_ssm_document" "auto_update_ssm_agent" {
  name = "AWS-UpdateSSMAgent"
}

resource "aws_ssm_association" "example" {
  association_name = "SystemAssociationForSsmAgentUpdate"
  name             = data.aws_ssm_document.auto_update_ssm_agent.name

  schedule_expression = "rate(14 days)"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.tunneling.id]
  }
}

resource "aws_ssm_document" "session_manager_preferences" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold regional settings for Session Manager"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName        = aws_s3_bucket.maybeclean_bucket.bucket
      s3EncryptionEnabled = false
    }
  })
}
