variables {
  notification_email = "test@example.com"
}

run "cloudwatch_plan_check" {
  command = plan 

  assert {
    condition = aws_cloudwatch_metric_alarm.ec2_cpu.threshold == 70
    error_message = "EC2 CPUアラームのthresholdが70ではありません"
  }

  assert {
    condition = aws_cloudwatch_metric_alarm.ec2_cpu.period == 300
    error_message = "EC2 CPUアラームのperiodが300ではありません"
  }

  assert {
    condition = aws_cloudwatch_metric_alarm.ec2_cpu.evaluation_periods == 3
    error_message = "EC2 CPUアラームのevaluation_periodsが3ではありません"
  }

  assert {
    condition = aws_cloudwatch_metric_alarm.elb_5xx.threshold == 5
    error_message = "ELB 5xxアラームのthresholdが5ではありません"
  }

  assert {
    condition = aws_sns_topic.alarm.name == "aws-study-alarm-topic"
    error_message = "SNS Topicの名前が想定と異なります"
  }

  assert {
    condition = aws_sns_topic_subscription.email.protocol == "email"
    error_message = "SNS Subscriptionのprotocolがemailではありません"
  }
}

run "security_group_plan_check" {
  command = plan

  assert {
    condition =  anytrue([for rule in aws_security_group.elb.ingress : rule.from_port == 80])
    error_message = "ELB SGのingressポートが80ではありません"
  }

  assert {
    condition = anytrue([for rule in aws_security_group.ec2.ingress : rule.from_port == 8080])
    error_message = "EC2 SGのingressポートが8080ではありません"
  }

  assert {
    condition = anytrue([for rule in aws_security_group.rds.ingress : rule.from_port == 3306])
    error_message = "RDS SGのingressポートが3306ではありません"
  }

  assert {
    condition = alltrue([for rule in aws_security_group.elb.ingress : rule.from_port != 22])
    error_message = "ELB SGにSSHポート(22)が開放されています"
  }

  assert {
    condition = alltrue([for rule in aws_security_group.ec2.ingress : rule.from_port != 22])
    error_message = "EC2 SGにSSHポート(22)が開放されています"
  }

  assert {
    condition = alltrue([for rule in aws_security_group.rds.ingress : rule.from_port != 22])
    error_message = "RDS SGにSSHポート(22)が開放されています"
  }
}
