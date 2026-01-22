resource "aws_securityhub_finding_aggregator" "this" {
  linking_mode      = var.linking_mode
  specified_regions = var.linking_mode == "SPECIFIED_REGIONS" ? var.specified_regions : null
  #tags              = var.tags
}