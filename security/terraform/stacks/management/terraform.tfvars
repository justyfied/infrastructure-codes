management_profile = "mgmt"
region = "us-east-1"

project = "secure-portfolio"
ous = ["Security", "Infrastructure", "Workloads"]

accounts = {
  log_archive = {
    name    = "LogArchive"
    email   = "your+logarchive@example.com"
    ou_name = "Security"
  }
  security = {
    name    = "Security"
    email   = "your+security@example.com"
    ou_name = "Security"
  }
  prod = {
    name    = "Prod"
    email   = "your+prod@example.com"
    ou_name = "Workloads"
  }
}
