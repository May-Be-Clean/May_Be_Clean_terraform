resource "aws_iam_role" "elastic_beanstalk" {
  name               = "aws-elasticbeanstalk-service-role"
  assume_role_policy = data.aws_iam_policy_document.elastic_beanstalk_assume_role.json
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_AWSElasticBeanstalkRoleCore" {
  role       = aws_iam_role.elastic_beanstalk.id
  policy_arn = data.aws_iam_policy.AWSElasticBeanstalkRoleCore.arn
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_AWSElasticBeanstalkEnhancedHealth" {
  role       = aws_iam_role.elastic_beanstalk.id
  policy_arn = data.aws_iam_policy.AWSElasticBeanstalkEnhancedHealth.arn
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_AWSElasticBeanstalkWebTier" {
  role       = aws_iam_role.elastic_beanstalk.id
  policy_arn = data.aws_iam_policy.AWSElasticBeanstalkWebTier.arn
}

