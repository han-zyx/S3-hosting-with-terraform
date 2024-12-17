#create S3 bucket
resource "aws_s3_bucket" "Testbucket" {
  bucket = var.bucketname
}

#change bucket Ownership
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.Testbucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#give public access to the bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.Testbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#set acl to public
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.Testbucket.id
  acl    = "public-read"
}