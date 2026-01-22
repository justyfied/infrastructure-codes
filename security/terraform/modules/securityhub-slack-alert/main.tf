data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# -------------------------
# Secrets Manager (Slack webhook)
# -------------------------
resource "aws_secretsmanager_secret" "slack" {
  name        = "${var.name}-slack-webhook"
  description = "Slack webhook for Security Hub alerts"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "slack" {
  secret_id     = aws_secretsmanager_secret.slack.id
  secret_string = var.slack_webhook_url
}

# -------------------------
# IAM role for Lambda
# -------------------------
resource "aws_iam_role" "lambda" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "read_secret" {
  name = "${var.name}-read-secret"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = aws_secretsmanager_secret.slack.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "read_secret" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.read_secret.arn
}

# -------------------------
# Lambda function
# -------------------------
resource "aws_lambda_function" "this" {
  function_name = var.name
  role          = aws_iam_role.lambda.arn
  runtime       = "python3.12"
  handler       = "index.handler"

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = {
      SECRET_ARN     = aws_secretsmanager_secret.slack.arn
      SLACK_CHANNEL  = var.slack_channel
      SLACK_USERNAME = var.slack_username
      LOG_LEVEL      = "INFO"
    }
  }

  tags = var.tags
}

# -------------------------
# EventBridge rule (Security Hub findings)
# -------------------------
resource "aws_cloudwatch_event_rule" "securityhub" {
  name        = "${var.name}-rule"
  description = "Send HIGH/CRITICAL Security Hub findings to Slack"

  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        Severity = {
          Label = var.severity_labels
        }
      }
    }
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.securityhub.name
  target_id = "SlackLambda"
  arn       = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.securityhub.arn
}
