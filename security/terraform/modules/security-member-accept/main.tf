# GuardDuty: enable detector + accept invite
resource "aws_guardduty_detector" "this" {
  enable = true
  tags   = var.tags
}

resource "aws_guardduty_invite_accepter" "this" {
  detector_id       = aws_guardduty_detector.this.id
  master_account_id = var.security_account_id
}

# Security Hub: enable + accept invite
resource "aws_securityhub_account" "this" {}

resource "aws_securityhub_invite_accepter" "this" {
  master_id   = var.security_account_id
  depends_on  = [aws_securityhub_account.this]
}