variable "name" { type = string }
variable "s3_bucket_name" { type = string }
variable "s3_key_prefix" { 
   type = string
   default = "cloudtrail" 
}
variable "kms_key_id" { 
   type        = string
   default     = null
   description = "KMS key ARN or ID for CloudTrail encryption"
}
variable "is_organization_trail" { 
   type     = bool 
   default  = true 
}
variable "enable_log_file_validation" { 
   type     = bool
   default  = true 
}
variable "tags" { 
   type = map(string)
   default = {} 
}
