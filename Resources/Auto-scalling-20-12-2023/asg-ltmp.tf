resource "aws_launch_template" "asg-ltmp" {
  name_prefix   = "asg-temp"
  image_id      = "ami-0b2b6dd6de40a361b"
  instance_type = "t3.micro"
}
