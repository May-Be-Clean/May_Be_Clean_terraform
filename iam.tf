data "aws_iam_policy_document" "assume" {
  statement {
    sid = "ec2StsAssumeRole"
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "web" {
  statement {
    actions = [
      "ssm:GetParameter",
    ]
    effect = "Allow"
    resources = toset([
      "arn:aws:ssm:${local.region}:${local.account_id}:parameter/${local.common_project_name}-*"
    ])
  }
}

data "aws_iam_policy_document" "tunneling_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}