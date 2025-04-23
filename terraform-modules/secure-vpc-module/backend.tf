terraform {
   backend "s3" {
      bucket         = "your-unique-tf-state-bucket"
      key            = "secure-vpc/terraform.tfstate"
      region         = "us-east-1"
      encrypt        = true
      dynamodb_table = "terraform-locks"
   }
}
