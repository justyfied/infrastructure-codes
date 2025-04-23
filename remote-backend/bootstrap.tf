provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "tf_state" {
    bucket = "your-unique-tf-state-bucket"  # Must be globally unique
    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
        }
        }
    }

    lifecycle {
        prevent_destroy = true
    }

    tags = {
        Name = "terraform-state"
    }
}

resource "aws_dynamodb_table" "tf_locks" {
    name         = "terraform-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }

    tags = {
        Name = "terraform-state-lock"
    }
}
