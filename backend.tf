terraform {
  backend "s3" {
    bucket         = "pranav--terraform-state-bucket"
    key            = "prod/webserver/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pranav-terraform-lock-table"
    encrypt        = true
  }
}
