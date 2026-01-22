#Step 1
resource "aws_organizations_organization" "this" {
  feature_set          = var.org_features
  enabled_policy_types = var.enabled_policy_types
}

# Create top-level OUs under root
resource "aws_organizations_organizational_unit" "ou" {
  for_each  = toset(var.ous)
  name      = each.value
  parent_id = aws_organizations_organization.this.roots[0].id
}

# Create accounts
resource "aws_organizations_account" "acct" {
  for_each = var.accounts
  name      = each.value.name
  email     = each.value.email
  role_name = try(each.value.role_name, "OrganizationAccountAccessRole")
  # Put in the right OU
  parent_id = aws_organizations_organizational_unit.ou[each.value.ou_name].id
  tags = var.tags
  lifecycle {
    prevent_destroy = true
  }
}
