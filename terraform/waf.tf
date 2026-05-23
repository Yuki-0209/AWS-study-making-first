# ---------------------
# CloudWatch Log Group
# ---------------------
resource "aws_cloudwatch_log_group" "waf" {
  name              = "aws-waf-logs-aws-study" 
  retention_in_days = 14
}

# ---------------------
# WAF Web ACL
# ---------------------
resource "aws_wafv2_web_acl" "main" {
  name  = "aws-study-web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "BlockTestURI"
    priority = 0

    action {
      block{}
    }

    statement {
      byte_match_statement {
        search_string = "/block-test"

        field_to_match {
          uri_path {}   
        }

        text_transformation {
          priority = 0 
          type = "NONE"
        }
        positional_constraint = "CONTAINS"
      }
    }
    
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockTestMetric" 
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none{}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    
    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSetMetric" 
    }
  }
  
  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "WebACLMetric"
  }
  
  tags = {
    Name = "aws-study-web-acl" 
  }
}

# ---------------------
# WAF Web ACL Association
# ---------------------
resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.main.id
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# ---------------------
# WAF Logging Configuration
# ---------------------
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  resource_arn = aws_wafv2_web_acl.main.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
}