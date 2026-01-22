variable "region" { 
   type = string
   default = "us-east-1" 
}
variable "management_profile" { 
   type = string 
}
variable "org_id" { 
   type = string 
}
variable "management_account_id" { 
   type = string 
}
variable "log_archive_account_id" { 
   type = string 
}
variable "org_access_role_name" { 
   type = string
   default = "OrganizationAccountAccessRole" 
}
variable "log_bucket_name" { 
   type = string 
}
variable "tags" { 
   type = map(string)
   default = {} 
}
