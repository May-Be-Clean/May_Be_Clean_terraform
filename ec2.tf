# EC2
resource "aws_eip" "public" {
  instance = aws_instance.public.id
  vpc      = true
  tags = {
    Name = "${var.project_name}-${var.environment}-public"
  }
}

resource "aws_instance" "public" {
  ami                     = var.public_ami
  instance_type           = var.public_instance_type
  vpc_security_group_ids  = [aws_security_group.public_ec2.id]
  iam_instance_profile    = aws_iam_instance_profile.public.name
  subnet_id               = aws_subnet.public1.id
  key_name                = "yourssu-key"
  disable_api_termination = true
  root_block_device {
    volume_size           = var.public_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    tags = {
      Name = "${var.project_name}-${var.environment}-public"
    }
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-public-ec2"
  }
}