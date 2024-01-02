# creating ALB
resource "aws_lb" "application-lb" {
  name               = "Auto-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  security_groups    = [aws_security_group.alb_sg.id]
  ip_address_type    = "ipv4"

  tags = {
    name = "Auto-alb"
  }
}
