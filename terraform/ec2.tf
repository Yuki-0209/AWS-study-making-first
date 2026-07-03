# ---------------
# IAM Role
# ---------------
resource "aws_iam_role" "ec2" {
  name = "aws-study-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ---------------
# IAM Managed Policy Attachment
# ---------------
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ---------------
# IAM Inline Policy
# ---------------
resource "aws_iam_role_policy" "secrets_access" {
  name = "SecretsAccess"
  role = aws_iam_role.ec2.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = aws_secretsmanager_secret.db.arn
      }
    ]
  })
}

# ---------------
# IAM Instance Profile
# ---------------
resource "aws_iam_instance_profile" "ec2" {
  name = "aws-study-ec2-profile"
  role = aws_iam_role.ec2.name
}

# ---------------
# EC2
# ---------------
resource "aws_instance" "main" {
  ami                                  = data.aws_ami.amazon_linux_2023.id
  instance_type                        = "t2.micro"
  subnet_id                            = aws_subnet.private_a.id
  vpc_security_group_ids               = [aws_security_group.ec2.id]
  iam_instance_profile                 = aws_iam_instance_profile.ec2.name
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  monitoring                           = false

  tags = {
    Name = "aws-study-ec2" 
  }
}

# ---------------
# Data Source: Latest Amazon Linux 2023 AMI
# ---------------
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
