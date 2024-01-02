resource "aws_instance" "rds-ec2" {
  ami           = "ami-00b8917ae86a424c9" # amazon linux 2 ami
  instance_type = "t2.micro"
  subnet_id      = aws_subnet.private-subnet-1.id
  associate_public_ip_address = false
  key_name = "git-test"
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ssm-resources-iam-profile.name  # Associate the IAM role with the instance

    user_data = <<-EOF
              #!/bin/bash
              sudo yum install mysql -y
              # Add more commands or scripts as needed
              EOF

  tags = {
    Name = "ec2-rds"
  }
}
