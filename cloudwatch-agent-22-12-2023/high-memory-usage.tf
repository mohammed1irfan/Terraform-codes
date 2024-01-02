resource "aws_cloudwatch_metric_alarm" "high_memory_usage" {
  alarm_name          = "high-memory-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This alarm monitors EC2 memory usage"
  alarm_actions       = ["arn:aws:sns:us-east-1:922524901295:Autoscalling"]

  dimensions = {
    InstanceId = aws_instance.nginx-web.id
  }
}
