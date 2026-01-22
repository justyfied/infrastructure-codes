variable "bucket_name" { type = string }
variable "org_id" { type = string }

variable "kms_alias" { 
   type = string
   default = "log-archive" 
}
variable "management_account_id" {
  type        = string
  description = "Management (payer) account ID"
}
variable "force_destroy" { 
   type = bool
   default = false 
}
variable "tags" { 
   type = map(string)
   default = {} 
}
