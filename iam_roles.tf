resource "aws_iam_role" "elastic_beanstalk_instance" {
  name               = local.common_project_name
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_instance_profile" "elastic_beanstalk_instance" {
  name = local.common_project_name
  role = aws_iam_role.elastic_beanstalk_instance.name
}

resource "aws_iam_role_policy" "elastic_beanstalk_instance" {
  name   = "${local.common_project_name}-elastic-beanstalk-instance"
  role   = aws_iam_role.elastic_beanstalk_instance.id
  policy = data.aws_iam_policy_document.elastic_beanstalk.json
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_instance" {
  role       = aws_iam_role.elastic_beanstalk_instance.id
  policy_arn = data.aws_iam_policy.AWSElasticBeanstalkWebTier.arn
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_instance_with_s3" {
  role       = aws_iam_role.elastic_beanstalk_instance.id
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}

data "aws_iam_policy" "AWSElasticBeanstalkWebTier" {
  name = "AWSElasticBeanstalkWebTier"
}

data "aws_iam_policy" "AWSElasticBeanstalkRoleCore" {
  name = "AWSElasticBeanstalkRoleCore"
}

data "aws_iam_policy" "AWSElasticBeanstalkEnhancedHealth" {
  name = "AWSElasticBeanstalkEnhancedHealth"
}

data "aws_iam_policy" "AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy" {
  name = "AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  name = "AmazonS3FullAccess"
}

data "aws_iam_policy_document" "elastic_beanstalk" {
  statement {
    sid = "AllowGetSSMParameter"
    actions = [
      "ssm:GetParameter",
    ]
    effect = "Allow"
    resources = toset([
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/${local.common_project_name}-*"
    ])
  }

  statement {
    sid = "AllowDescribeEnvironments"
    actions = [
      "elasticbeanstalk:DescribeEnvironments",
    ]
    effect = "Allow"
    resources = toset([
      "arn:aws:elasticbeanstalk:${local.region}:${local.account_id}:environment/${local.common_project_name}/*",
    ])
  }
}

data "aws_iam_policy_document" "elastic_beanstalk_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      values   = ["elasticbeanstalk"]
      variable = "sts:ExternalId"
    }
  }
}