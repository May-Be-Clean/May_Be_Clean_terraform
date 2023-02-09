resource "aws_s3_bucket" "yourssu_bucket" {
  bucket = "${local.common_project_name}-bucket"

  ## 실수로 S3 버킷을 삭제하는 것을 방지
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_acl" "yourssu_bucket_acl" {
  bucket = aws_s3_bucket.yourssu_bucket.id
  acl    = "private"
}

# 다이나모 DB에 테이블을 생성한다.
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}