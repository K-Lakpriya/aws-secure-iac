resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "${var.environment}-cloudtrail-logs-${var.product_name}/aws/cloudtrail/logs"
  retention_in_days = 90
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {
  alarm_name          = "UnauthorizedAPICalls"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnauthorizedOperation"
  namespace           = "${var.environment}/${var.product_name}/AWS/CloudTrail"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when unauthorized API calls occur"
  treat_missing_data  = "notBreaching"

  # Optional: add SNS topic ARN for notifications
  alarm_actions = []
}
