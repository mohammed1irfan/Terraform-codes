resource "aws_route_table_association" "private-rt-association1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.pvt_route_tb.id
}
