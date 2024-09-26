resource "aws_cloudwatch_metric_alarm" "disk_use" {
  alarm_name                = "ec2-disk-usage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "disk_used_percent"
  namespace                 = "CWAgent"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "20"
  alarm_description         = "This metric monitors ec2 disk utilization"
  actions_enabled           = "true"
  alarm_actions             = ["arn:aws:sns:us-east-1:922524901295:Autoscalling"]
  insufficient_data_actions = []
  #treat_missing_data = "notBreaching"

   dimensions = {
    path = "/"
    InstanceId = "aws_instance.nginx-web.id"
    device = "/dev/sda1"
    fstype = "ext4"
  }
}
