resource "null_resource" "health_check" {

 provisioner "local-exec" {

    command = "/bin/bash object.sh"
  }

depends_on = [aws_s3_bucket_public_access_block.example]

}

