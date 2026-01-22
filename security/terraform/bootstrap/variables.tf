variable "region" { 
   type = string 
   default = "us-east-1" 
}
variable "management_profile" { 
   type = string 
}

variable "tf_state_bucket_name" { 
   type = string 
}
variable "tf_lock_table_name" { 
   type = string
   default = "terraform-locks" 
}

variable "tags" { 
   type = map(string)
   default = {} 
   }
