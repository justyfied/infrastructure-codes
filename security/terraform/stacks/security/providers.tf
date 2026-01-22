terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

# Management provider (uses your single mgmt credential)
provider "aws" {
  alias   = "mgmt"
  region  = var.region
  profile = var.management_profile
}

# We'll define the security provider AFTER we know the account id from remote state,
# so provider config is in main.tf via locals + provider "aws" block is not allowed.
# Terraform requires providers in providers.tf, but can interpolate variables.
# We'll pass security_account_id as a variable computed from remote state using locals.

# AssumeRole into Security account
provider "aws" {
  alias  = "sec"
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${var.security_account_id}:role/${var.org_access_role_name}"
  }
}

# Prod
provider "aws" {
  alias  = "prod"
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.member_accounts["prod"].account_id}:role/${var.org_access_role_name}"
  }
}

# Dev
provider "aws" {
  alias  = "dev"
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.member_accounts["dev"].account_id}:role/${var.org_access_role_name}"
  }
}

# Shared Services
provider "aws" {
  alias  = "shared"
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.member_accounts["shared_services"].account_id}:role/${var.org_access_role_name}"
  }
}
