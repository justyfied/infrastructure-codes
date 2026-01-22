# Step 2
terraform {
  backend "s3" {
    bucket         = "YOUR_TF_STATE_BUCKET" # From Step 0
    key            = "stacks/log-archive/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
