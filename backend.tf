terraform {
  backend "s3" {
    bucket         = "jolomiayu-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-lock"
  }
}
