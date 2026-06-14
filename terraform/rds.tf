# ------------------
# DBSecret
# ------------------

resource "aws_secretsmanager_secret" "db" {
  name = "mydb-secret"
}

# ------------------
# DBSecretの値
# ------------------
resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}?"
}

# ------------------
# DBSecreの格納先シークレット
# ------------------
resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db.result
  })
}

# ------------------
# DB Subnet Group
# ------------------
resource "aws_db_subnet_group" "main" {
  description = "DB Subnet Group"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_c.id,
  ]

  tags = {
    Name = "aws-study-db-subnet-group"
  }
}

# ------------------
# RDS
# ------------------
resource "aws_db_instance" "main" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t4g.micro"
  db_name           = "mydb"

  username = jsondecode(aws_secretsmanager_secret_version.db.secret_string)["username"]
  password = jsondecode(aws_secretsmanager_secret_version.db.secret_string)["password"]
  port     = 3306

  db_subnet_group_name        = aws_db_subnet_group.main.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  backup_retention_period     = 1
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  license_model               = "general-public-license"
  deletion_protection         = false
  skip_final_snapshot         = true

  tags = {
    Name = "mydb"
  }
}
