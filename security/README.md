“Security account is delegated admin for GuardDuty & Security Hub”

“Existing accounts are auto-enrolled and invites accepted via Terraform using cross-account AssumeRole”

“New accounts are auto-enabled via org configuration (already in your earlier modules)”




# STEP 0
Create a one time bootstrap for state bucket and lock table in the Management Account
#### see security/terraform/bootstrap for code.

# Run bootstrap
`cd terraform/bootstrap
terraform init
terraform apply`

1) Shared backend settings for all stacks (S3 + Dynamo lock)

Each stack will have its own backend.tf with a unique key.

Note: backend blocks don’t accept variables, so you hardcode bucket/table once (that’s normal).

2) Providers with AssumeRole (management creds only)

You’ll keep one local AWS profile (management), and Terraform will assume roles into other accounts.

Typical role name: OrganizationAccountAccessRole (default created by Organizations account creation)

3) Management stack (creates org + accounts, then reads log-archive remote

4) Log-archive stack (assume role into log archive acct + write its own state)

5) Apply order (no copy/paste of outputs except IDs once)

You still need to pass org_id and account IDs into log-archive (Terraform can’t assume a role into an account it hasn’t been told about). But you do NOT need to pass bucket/kms back.



# Step 1 — Management stack -- create org + accounts
#### see terraform/stacks/management/* for codes

In the management account, create the following:

- AWS Organization
- OUs
- Accounts: Security, Log-Archive, Prod, Dev, Shared_Services

### Expected Outputs
- Org_id
- account_ids (IDs for each account)

`cd terraform/stacks/management
terraform init
terraform apply`

Grab these from outputs:

- org_id

- account_ids.log_archive

- management_account_id

# Step 2 — apply log-archive (assume role into log archive)
#### Terraform: terraform/stacks/log-archive/* reads mgmt remote state for org/account IDs.
Terraform will run with mgmt credentials to assume role into the log-archive account to create the following:

- KMS key for logs
- S3 bucket for centralized logs
- Bucket policy allowing CloudTrail org trail delivery

### Expected Outputs
- log_bucket_name
- log_kms_key_arn

Set in terraform/stacks/log-archive/terraform.tfvars:
`management_profile      = "mgmt"
region                  = "us-east-1"

org_id                  = "o-xxxxxxx"
management_account_id   = "111111111111"
log_archive_account_id  = "222222222222"

log_bucket_name         = "secure-portfolio-log-archive-222222222222"`

#### Then:

`cd terraform/stacks/log-archive
terraform init
terraform apply`

The management account can then read from remote state and creates the organization trail:
- log_bucket_name
- log_kms_key_arn



# STEP 3 - Management stack Create Org CloudTrail to Log-Archive bucket
### This takes place in the mgmt account.
#### Terraform: terraform/stacks/management/* reads log-archive remote state.
Creates Org CloudTrail that writes to log archive bucket using the kms key created in step 2. 

This org Trail ensures that org logging is centralized. 

Apply management again 
```
cd terraform/stacks/management
terraform apply
```


# STEP 4 - Security-Admin stack: Delegated admin + enable Security Hub + aggregation + invites
### This takes place in mgmt acct, Tf uses mgmt credential to assume role into security account. 
#### Terraform: terraform/stacks/security-admin/*

### On the management side
- set security acct as delegeted admin for Security Hub and GuardDuty

### On the Security side 
- Enable Security Hub in Security acct
- Turn on org auto-enable
- create finding aggregator 
- Invite existing member accounts (prod/dev/shared)

### Expected Outputs
- security_account_id
- (optional) aggregator_arn



# STEP 5 - Member stacks (prod/dev/shared-services): Accept invites
### Terraform assumes into each member account and creates in each member account the following:
#### Terraform: terraform/stacks/members/prod|dev|shared-services/*
- Enable Security Hub
- Accept invite from Security account
All findings roll up into Security acct and aggregated.



# STEP 6 - Slack alerts: EventBridge → Lambda → Slack webhook
### This takes place in the security account. The following are created.
- Secrets Manager secret for Slack webhook
- Lambda that reads secret + posts to Slack
- EventBridge rule that triggers for HIGH/CRITICAL findings
- Permission for EventBridge to invoke Lambda
This will allow you to get high/critical Slack alerts.












# Apply Order
1. bootstrap (one-time)

2. stacks/management apply

3. stacks/log-archive apply

4. stacks/management apply (CloudTrail gets created now)

5. stacks/security-admin apply (delegation + enable + aggregator + invites + slack)

6. stacks/members/prod apply

7. stacks/members/dev apply

8. stacks/members/shared-services apply






## How to run the Security stack
1) Apply management (creates accounts)

`cd terraform/stacks/management
terraform apply`

2) Put the security account id into stacks/security/terraform.tfvars

3) Apply security stack

`cd terraform/stacks/security
terraform init
terraform apply`


“Security account is delegated admin for GuardDuty & Security Hub”

“Existing accounts are auto-enrolled and invites accepted via Terraform using cross-account AssumeRole”

“New accounts are auto-enabled via org configuration (already in your earlier modules)”