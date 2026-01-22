resource "aws_guardduty_member" "member" {
  for_each = var.members

  detector_id                 = var.detector_id
  account_id                  = each.value.account_id
  email                       = each.value.email
  invite                      = true
  disable_email_notification   = true
}
