resource "aws_instance" "nginx-web" {
ami           = "ami-0b2b6dd6de40a361b" # us-east-1
instance_type = "t2.micro"
key_name = "git-test"
associate_public_ip_address = true	
subnet_id      = "subnet-08b69000308a4abb2"
iam_instance_profile = aws_iam_instance_profile.this.name
vpc_security_group_ids = [aws_security_group.public-sg.id]
user_data = "${file("nginx.sh")}"

 
tags = {
Name = "nginx-web"
  }
 }

