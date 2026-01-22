output "lambda_arn" {
  description = "Slack alerting Lambda ARN"
  value       = aws_lambda_function.this.arn
}

output "slack_secret_arn" {
  description = "Secrets Manager ARN containing Slack webhook"
  value       = aws_secretsmanager_secret.slack.arn
}
