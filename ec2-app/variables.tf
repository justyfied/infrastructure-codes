variable "region" {
  type    = string
  default = "us-east-1"
}

variable "github_oauth_token" {
  type = string
  description = "GitHub OAuth token for repository access"
}

variable "aws_account_id" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "alarm_action" {
  type        = list(string)
  description = "List of actions to trigger when alarm is activated (e.g., SNS topic ARN)"
}

variable "notification_email" {
  type        = string
  description = "Email address to send alarm notifications"
}
