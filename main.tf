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

#Adding Objects
resource "aws_s3_object" "index" {
 bucket = aws_s3_bucket.Testbucket.id
  key    = "index.html"
  source = "index.html"

  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.Testbucket.id
  key    = "error.html"
  source = "error.html"

  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "sample" {
  bucket = aws_s3_bucket.Testbucket.id
  key    = "sample.png"
  source = "sample.png"

  acl = "public-read"
}

#enable public hosting 
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.Testbucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  
  depends_on = [ aws_s3_bucket_acl.example ]
}