#Step 1
variable "region" { 
   type = string
   default = "us-east-1" 
}
variable "management_profile" { type = string }

variable "project" { 
   type = string
   default = "secure-portfolio" 
}

variable "ous" { type = list(string) }

variable "accounts" {
  type = map(object({
    name    = string
    email   = string
    ou_name = string
  }))
}


# Remote state bucket/table must match backend.tf
# After log-archive stack is applied, you'll set these:
variable "log_bucket_name" { 
   type = string 
   default = "" 
}
variable "log_kms_key_arn" { 
   type = string 
   default = "" 
}

variable "tags" { 
   type = map(string) 
   default = {}
}
