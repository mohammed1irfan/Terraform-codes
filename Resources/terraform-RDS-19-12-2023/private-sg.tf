resource "aws_security_group" "private-sg" {
name = "rds-private-sg"
vpc_id = aws_vpc.hadiya_project_vpc.id
ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }

ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
  }


  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
tags = {
    Name = "rds-sg"
  }
}
