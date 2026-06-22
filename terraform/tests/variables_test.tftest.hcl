variables {
  notification_email = "test@example.com"
}

run "email_variablie_is_string" {
  command = plan

  assert {
    condition     = var.notification_email == "test@example.com"
    error_message = "notification_emailが期待値と一致しません"
  }
}
