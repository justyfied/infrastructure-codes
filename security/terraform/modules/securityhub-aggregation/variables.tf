variable "linking_mode" { 
   type = string
   default = "ALL_REGIONS" 
}
variable "specified_regions" { 
   type = list(string)
   default = [] 
}
variable "tags" { 
   type = map(string)
   default = {} 
}