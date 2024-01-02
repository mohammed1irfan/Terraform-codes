resource "aws_route_table" "pvt_route_tb" {
  vpc_id = aws_vpc.hadiya_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    Name = "pvt_route_tb"
  }
}
