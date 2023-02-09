data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "systems_manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "cloudwatch_agent" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
}

data "aws_iam_policy" "code-deploy-ec2" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

# IAM Role
## public
resource "aws_iam_role" "public" {
  name               = "${var.project_name}-${var.environment}-public-iamrole"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "public_ssm" {
  role       = aws_iam_role.public.name
  policy_arn = data.aws_iam_policy.systems_manager.arn
}

resource "aws_iam_role_policy_attachment" "public_cloudwatch" {
  role       = aws_iam_role.public.name
  policy_arn = data.aws_iam_policy.cloudwatch_agent.arn
}

resource "aws_iam_role_policy_attachment" "public_code_deploy" {
  role       = aws_iam_role.public.name
  policy_arn = data.aws_iam_policy.code-deploy-ec2.arn
}

resource "aws_iam_instance_profile" "public" {
  name = "${var.project_name}-${var.environment}-public-instanceprofile"
  role = aws_iam_role.public.name
}

## CodeDeploy
data "aws_iam_policy_document" "code_deploy_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "code-deploy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role" "code_deploy" {
  name               = "${var.project_name}-${var.environment}-code-deploy-iamrole"
  assume_role_policy = data.aws_iam_policy_document.code_deploy_role.json
}

resource "aws_iam_role_policy_attachment" "code_deploy" {
  role       = aws_iam_role.code_deploy.name
  policy_arn = data.aws_iam_policy.code-deploy.arn
}

resource "aws_iam_instance_profile" "code_deploy" {
  name = "${var.project_name}-${var.environment}-code-deploy-instanceprofile"
  role = aws_iam_role.code_deploy.name
}