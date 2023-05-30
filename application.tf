resource "aws_elastic_beanstalk_application" "server_api" {
  name = local.common_project_name

  appversion_lifecycle {
    service_role          = aws_iam_role.elastic_beanstalk.arn
    max_age_in_days       = 7
    delete_source_from_s3 = true
  }
}
