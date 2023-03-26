terraform {
  backend "s3" {
    bucket         = "poc-infra-s3"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
  }
}