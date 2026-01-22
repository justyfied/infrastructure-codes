resource "aws_securityhub_account" "this" {}

# Enable AWS Foundational Security Best Practices (AFSBP)
# (This is a good default for portfolios; you can add CIS later if you want.)
resource "aws_securityhub_standards_subscription" "afsbp" {
  count        = var.enable_aws_foundational_best_practices ? 1 : 0
  standards_arn = "arn:aws:securityhub:::standards/aws-foundational-security-best-practices/v/1.0.0"
}

# Org configuration: auto-enable for new accounts (requires delegated admin already set)
resource "aws_securityhub_organization_configuration" "this" {
  auto_enable = var.auto_enable
  depends_on  = [aws_securityhub_account.this]
}
