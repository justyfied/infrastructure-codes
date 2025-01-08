resource "aws_secretsmanager_secret" "ec2_private_key" {
  name        = "ec2-private-key"
  description = "Private key for EC2 instances"
}

resource "aws_secretsmanager_secret_version" "ec2_private_key_version" {
  secret_id     = aws_secretsmanager_secret.ec2_private_key.id
  secret_string = var.ec2_private_key
}
