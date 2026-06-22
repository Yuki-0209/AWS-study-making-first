variables {
  notification_email = "test@example.com"
}

run "vpc_and_ec2_plan_check" {
  command = plan

  assert {
    condition     = aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "VPCのCIDRブロックが想定と異なります"
  }

  assert {
    condition     = aws_subnet.public_a.map_public_ip_on_launch == true
    error_message = "PublicSubnetAはmap_public_ip_on_launchがtrueである必要がある"
  }

  assert {
    condition     = aws_subnet.private_a.map_public_ip_on_launch == false
    error_message = "PrivateSubnetAはmap_public_ip_on_launchがfalseである必要がある"
  }

  assert {
    condition     = aws_instance.main.instance_type == "t2.micro"
    error_message = "EC2インスタンスのインスタンスタイプが想定と異なります"
  }

  assert {
    condition     = aws_subnet.public_a.availability_zone == "ap-northeast-1a"
    error_message ="PublicSubnetAのAZが想定と異なります" 
  }
}
