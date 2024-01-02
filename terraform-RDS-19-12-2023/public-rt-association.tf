resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.pub_route_tb.id
}
