resource "aws_route_table" "pub_route_tb" {
  vpc_id = aws_vpc.hadiya_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_hadiya_project.id
  }
  tags = {
    Name = "pub_route_tb"
  }
}
