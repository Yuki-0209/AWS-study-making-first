terraform {
  backend "s3" {
    bucket  = "aws-study-terraform-state"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}
