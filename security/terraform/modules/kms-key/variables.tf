variable "alias" { type = string }
variable "description" { type = string, default = "KMS key managed by Terraform" }
variable "deletion_window_in_days" { type = number, default = 30 }
variable "enable_key_rotation" { type = bool, default = true }

variable "key_policy_json" {
  type        = string
  description = "Optional full key policy JSON. If empty, a safe default is used."
  default     = ""
}

variable "tags" { type = map(string), default = {} }
