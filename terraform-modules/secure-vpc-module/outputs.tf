output "vpc_id" {
   description = "The ID of the created VPC"
   value       = module.secure_vpc.vpc_id
}

output "public_subnet_ids" {
   description = "List of public subnet IDs"
   value       = module.secure_vpc.public_subnet_ids
}

output "private_subnet_ids" {
   description = "List of private subnet IDs"
   value       = module.secure_vpc.private_subnet_ids
}

output "nat_gateway_ids" {
   description = "List of NAT Gateway IDs"
   value       = module.secure_vpc.nat_gateway_ids
}

output "availability_zones" {
   description = "List of Availability Zones used"
   value       = var.availability_zones
}
