resource "aws_db_subnet_group" "rds-subnet-group" {
  name = "test"
  subnet_ids = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  tags = {
    "Name" = "rds-subnet-group"
  }

}

resource "aws_db_instance" "yourssu-inviter-rds" {
  allocated_storage = 20
  max_allocated_storage = 50
  publicly_accessible = true
  availability_zone = "ap-northeast-2a"
  db_subnet_group_name = aws_db_subnet_group.rds-subnet-group.name
  engine = "mysql"
  engine_version = "8.0.28"
  instance_class = "db.t2.small"
  skip_final_snapshot = true
  identifier = "inviter-mysql"
  username = "root"
  password = var.db_password
  port = "3306"
}
