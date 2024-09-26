resource "aws_autoscaling_group" "asg-tf" {
  availability_zones = ["us-east-1c"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  health_check_type    = "EC2"

  launch_template {
    id      = aws_launch_template.asg-ltmp.id
    version = "$Latest"
  }
}
