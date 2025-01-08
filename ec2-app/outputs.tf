output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "instance_ids" {
  value = module.ec2.instance_ids
}
