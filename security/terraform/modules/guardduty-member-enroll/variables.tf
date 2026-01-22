variable "detector_id" { type = string }

variable "members" {
  type = map(object({
    account_id = string
    email      = string
  }))
}

variable "tags" { 
   type = map(string)
   default = {} 
}
