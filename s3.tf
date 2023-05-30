resource "aws_s3_bucket" "maybeclean_bucket" {
  bucket = local.common_project_name
  tags = {
    Name = "${local.common_project_name}-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "maybeclean_bucket_ownership" {
  bucket = aws_s3_bucket.maybeclean_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "maybeclean_bucket_acl" {
  bucket = aws_s3_bucket.maybeclean_bucket.id
  acl    = "private"
}