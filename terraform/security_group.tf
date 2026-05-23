# ---------------
#elb_security_group
# ---------------
resource "aws_security_group" "elb" {
  description = "ELB SG"
  vpc_id = aws_vpc.main.id 

  ingress {
    protocol    =  "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws_study_elb_sg" 
  }
}

# ---------------
# ec2_security_group
# ---------------
resource "aws_security_group" "ec2" {
  description = "AWS Study EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port   = 8080
    security_groups = [aws_security_group.elb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws_study_ec2_sg"
  }
}

# ---------------
# rds_security_group
# ---------------
resource "aws_security_group" "rds" {
  description = "AWS Study RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws_study_rds_sg"
  }
}
