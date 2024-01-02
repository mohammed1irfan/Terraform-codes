resource "aws_s3_bucket_website_configuration" "static-website-bucket" {
  bucket = aws_s3_bucket.static-website-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "static-website-bucket" {
  bucket = aws_s3_bucket.static-website-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
