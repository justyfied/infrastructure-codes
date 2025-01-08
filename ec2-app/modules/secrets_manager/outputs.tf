output "secret_arn" {
  value = aws_secretsmanager_secret.ec2_private_key.arn
}