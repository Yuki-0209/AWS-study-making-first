# ---------------------
# SNS Topic
# ----------------------
resource "aws_sns_topic" "alarm" {
  name = "aws-study-alarm-topic"
}

# ---------------------
# SNS Subscription
# ----------------------
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarm.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# ---------------------
# Cloudwatch Alarm EC2 CPU Utilization Alarm
# ----------------------
resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name        = "aws-study-ec2-cpu-alarm"
  alarm_description = "AWS-study EC2のCPU使用率が70%以上になりました。"

  # 監視対象のメトリクス設定
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  dimensions = {
    InstanceId = aws_instance.main.id
  }

  # 集計設定
  unit      = "Percent"
  period    = 300
  statistic = "Average"

  # アラーム条件
  threshold           = 70
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  treat_missing_data  = "notBreaching"

  # アクション設定
  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alarm.arn]
}

# ---------------------
# Cloudwatch Alarm ELB5XX Alarm
# ----------------------
resource "aws_cloudwatch_metric_alarm" "elb_5xx" {
  alarm_name = "aws-study-elb-5xx-alarm"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  statistic = "Sum"
  period    = 300

  threshold           = 5
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alarm.arn]
}

# ---------------------
# WAF BlockedRequests Alarm
# ----------------------
resource "aws_cloudwatch_metric_alarm" "waf_blockd" {
  alarm_name        = "aws-study-waf-blocked-requests"
  alarm_description = "wAF Blocked requests detected"

  namespace   = "AWS/WAFV2"
  metric_name = "BlockRequests"

  dimensions = {
    WebACL = "aws-study-web-acl"
    Rule   = "ALL"
    Region = "ap-northeast-1"
  }

  statistic = "Sum"
  period    = 300

  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alarm.arn]
}