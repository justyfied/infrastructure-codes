output "instance_ids" {
  value = aws_instance.app_server[*].id
}

output "key_pair_name" {
  value = aws_key_pair.ec2_key.key_name
}
