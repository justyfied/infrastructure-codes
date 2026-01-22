output "security_account_id" {
  value = var.security_account_id
}

output "guardduty_detector_id" {
  value = module.guardduty.detector_id
}
