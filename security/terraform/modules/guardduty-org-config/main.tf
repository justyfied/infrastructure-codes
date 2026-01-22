


resource "aws_guardduty_detector" "mgmt" {
  enable = true
  tags   = var.tags
}

resource "aws_guardduty_organization_configuration" "this" {
  detector_id = aws_guardduty_detector.this.id
  auto_enable_organization_members = "ALL"

  datasources {
    s3_logs {
      auto_enable = true
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = true
        }
      }
    }
   }
}
