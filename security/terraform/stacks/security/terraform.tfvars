management_profile = "mgmt"
region            = "us-east-1"

tf_state_bucket   = "REPLACE_WITH_YOUR_TF_STATE_BUCKET"
tf_state_region   = "us-east-1"

# from management output: account_ids["security"]
security_account_id = "123456789012"

project = "secure-portfolio"


member_accounts = {
  prod = {
    account_id = "222222222222"
    email      = "your+prod@example.com"
  }
  dev = {
    account_id = "333333333333"
    email      = "your+dev@example.com"
  }
  shared_services = {
    account_id = "444444444444"
    email      = "your+shared@example.com"
  }
}
