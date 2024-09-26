locals {
  userdata = templatefile("nginx.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name
  })
}
