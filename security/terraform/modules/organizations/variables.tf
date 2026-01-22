variable "org_features" {
  type    = string
  default = "ALL"
}

variable "enabled_policy_types" {
  type    = list(string)
  default = ["SERVICE_CONTROL_POLICY"]
}

variable "ous" {
  type        = list(string)
  description = "Top-level OU names, e.g. [\"Security\",\"Infrastructure\",\"Workloads\"]"
  default     = []
}

variable "accounts" {
  type = map(object({
    name      = string
    email     = string
    ou_name   = string
    role_name = optional(string, "OrganizationAccountAccessRole")
  }))
  description = "Map of accounts to create."
}

variable "tags" { 
   type = map(string)
   default = {} 
}
