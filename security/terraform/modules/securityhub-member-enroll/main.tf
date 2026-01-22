resource "aws_securityhub_member" "member" {
  for_each = var.members

  account_id = each.value.account_id
  email      = each.value.email
  invite     = true
}
