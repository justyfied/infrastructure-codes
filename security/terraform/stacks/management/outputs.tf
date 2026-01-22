output "org_id" { value = module.org.org_id }
output "account_ids" { value = module.org.account_ids }

output "management_account_id" {
  value = data.aws_caller_identity.current.account_id
}

