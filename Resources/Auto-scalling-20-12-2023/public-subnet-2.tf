resource "aws_subnet" "public-subnet-2" {
  vpc_id     = "vpc-03678851cfe4ade16"
  cidr_block = "172.31.176.0/20"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}
