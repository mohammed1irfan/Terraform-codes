resource "aws_s3_bucket" "static-website-bucket" {
  bucket = "mycloudfront-buck" # give a unique bucket name
  tags = {
    Name = "static-website-bucket"
  }
}

