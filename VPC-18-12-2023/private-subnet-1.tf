resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.hadiya_project_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-1"
  }
}
