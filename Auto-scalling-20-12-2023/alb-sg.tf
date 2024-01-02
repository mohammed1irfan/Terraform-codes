resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "ALB Security Group"
  vpc_id      = "vpc-03678851cfe4ade16"

  # Define ingress rules (e.g., allow inbound traffic on port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with specific IP or range
  }

  # Define egress rules as needed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
