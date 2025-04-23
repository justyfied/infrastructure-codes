variable "vpc_cidr" {
   type        = string
   description = "CIDR block for the VPC"
}

variable "name_prefix" {
   type        = string
   description = "Prefix for naming resources"
}

variable "public_subnet_cidrs" {
   type        = list(string)
   description = "CIDRs for public subnets"
}

variable "private_subnet_cidrs" {
   type        = list(string)
   description = "CIDRs for private subnets"
}

variable "availability_zones" {
   type        = list(string)
   description = "Availability zones to deploy subnets in"
}
