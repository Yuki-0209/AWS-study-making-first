variables {
  notification_email = "test@example.com"
}

run "waf_plan_check" {
  command = plan 

  assert {
    condition = aws_wafv2_web_acl.main.scope == "REGIONAL"
    error_message = "WAF Web ACLのscopeがREGIONALではありません"
  }

  assert {
    condition = aws_cloudwatch_log_group.waf.retention_in_days == 14
    error_message = "CloudWatch Log Groupの保持期間が14日ではありません"
  }

  assert {
    condition = aws_cloudwatch_log_group.waf.name == "aws-waf-logs-aws-study"
    error_message = "CloudWatch Log Groupの名前が想定と異なります"
  }

  assert {
    condition     = anytrue([for rule in aws_wafv2_web_acl.main.rule : rule.name == "BlockTestURI" && rule.priority == 0])
    error_message = "BlockTestURIルールのpriorityが0ではありません"
  }

  assert {
    condition     = anytrue([for rule in aws_wafv2_web_acl.main.rule : rule.name == "AWS-AWSManagedRulesCommonRuleSet" && rule.priority == 1])
    error_message = "AWSManagedRulesCommonRuleSetのpriorityが1ではありません"
  }
}  
