data "terraform_remote_state" "mgmt" {
  backend = "s3"
  config = {
    bucket         = var.tf_state_bucket
    key            = "stacks/management/terraform.tfstate"
    region         = var.tf_state_region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}