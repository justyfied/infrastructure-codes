variable "name" {
  description = "Base name for Slack alerting resources"
  type        = string
}

variable "slack_webhook_url" {
  description = "Slack Incoming Webhook URL"
  type        = string
  sensitive   = true
}

variable "severity_labels" {
  description = "Security Hub severities to alert on"
  type        = list(string)
  default     = ["HIGH", "CRITICAL"]
}

variable "slack_channel" {
  description = "Optional Slack channel override"
  type        = string
  default     = ""
}

variable "slack_username" {
  description = "Slack username displayed for alerts"
  type        = string
  default     = "SecurityHub"
}

variable "tags" {
  type    = map(string)
  default = {}
}
