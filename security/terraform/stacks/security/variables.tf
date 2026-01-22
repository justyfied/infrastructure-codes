
variable "region" { 
   type = string
   default = "us-east-1" 
}
variable "management_profile" { type = string }

variable "tf_state_bucket" { type = string }
variable "tf_state_region" { 
   type = string
   default = "us-east-1" 
}

variable "org_access_role_name" {
  type    = string
  default = "OrganizationAccountAccessRole"
}

variable "project" { 
   type = string
   default = "secure-portfolio" 
}
variable "tags" { 
   type = map(string)
   default = {} 
}

# toggles
variable "guardduty_auto_enable" { 
   type = bool
   default = true 
}
variable "securityhub_auto_enable" { 
   type = bool
   default = true 
}

variable "security_account_id" {
  type        = string
  description = "Security account ID (from management stack output)"
}

variable "member_accounts" {
  description = "Existing workload accounts to enroll into Security services"
  type = map(object({
    account_id = string
    email      = string
  }))
}

# Optional: role name used in member accounts
variable "org_access_role_name" {
  type    = string
  default = "OrganizationAccountAccessRole"
}

# Slack webhook (sensitive)
variable "slack_webhook_url" { 
   type = string
   sensitive = true 
}
variable "project" { 
   type = string
   default = "secure-portfolio" 
}