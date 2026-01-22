variable "tags" { 
   type = map(string)
   default = {} 
}

# Auto-enable Security Hub for new member accounts
variable "auto_enable" { 
   type = bool
   default = true 
}

# Enable a baseline standard (AWS Foundational Security Best Practices)
variable "enable_aws_foundational_best_practices" { 
   type = bool
   default = true 
}
