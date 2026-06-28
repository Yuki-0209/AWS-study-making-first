variables {
  notification_email = "test@example.com"
}

run "rds_plan_check" {
  command = plan

  assert { 
    condition     = aws_db_instance.main.engine == "mysql"
    error_message = "RDSのエンジンがmysqlではありません"
  }

  assert {
    condition     = aws_db_instance.main.engine_version == "8.0"
    error_message = "RDSのエンジンバージョンが8.0ではありません"
  }

  assert {
    condition = aws_db_instance.main.instance_class == "db.t4g.micro"
    error_message = "RDSのインスタンスクラスが異なります"
  }

  assert {
    condition = aws_db_instance.main.allocated_storage == 20
    error_message = "RDSのストレージが20GBではありません"
  }

  assert {
    condition = aws_db_instance.main.deletion_protection == true
    error_message = "deletion_protectionがtrueではありません"
  }

  assert {
    condition = aws_db_instance.main.skip_final_snapshot == false
    error_message = "skip_final_snapshotがfalseではありません"
  }
}

run "elb_plan_check"{
  command = plan

  assert {
    condition = aws_lb.main.load_balancer_type == "application"
    error_message = "ELBのタイプがapplicationではありません"
  }

  assert {
    condition = aws_lb_listener.main.port == 80
    error_message = "ELBリスナーのポートが80ではありません"
  }

  assert {
    condition = aws_lb_listener.main.protocol == "HTTP"
    error_message = "ELBリスナーのプロトコルがHTTPではありません"
  }

  assert {
    condition = aws_lb_target_group.main.port == 8080
    error_message = "TargetGroupのポートが8080ではありません"
  }
}
