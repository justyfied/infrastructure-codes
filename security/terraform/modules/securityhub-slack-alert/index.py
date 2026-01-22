import json
import logging
import os
import urllib.request
import boto3

logger = logging.getLogger()
logger.setLevel(os.getenv("LOG_LEVEL", "INFO"))

secrets = boto3.client("secretsmanager")

def get_webhook(secret_arn):
    resp = secrets.get_secret_value(SecretId=secret_arn)
    return resp["SecretString"]

def format_finding(f):
    return (
        f"*{f.get('Severity', {}).get('Label', 'UNKNOWN')}* | "
        f"*{f.get('Title', 'Untitled')}*\n"
        f"• Account: `{f.get('AwsAccountId')}`  "
        f"Region: `{f.get('Region')}`  "
        f"Product: `{f.get('ProductName')}`\n"
        f"• ID: `{f.get('Id')}`"
    )

def handler(event, context):
    webhook = get_webhook(os.environ["SECRET_ARN"])
    findings = event.get("detail", {}).get("findings", [])

    if not findings:
        return {"status": "no_findings"}

    text = "\n\n".join(format_finding(f) for f in findings[:5])

    payload = {
        "username": os.environ.get("SLACK_USERNAME", "SecurityHub"),
        "text": f":rotating_light: Security Hub Findings ({len(findings)})\n\n{text}"
    }

    channel = os.environ.get("SLACK_CHANNEL")
    if channel:
        payload["channel"] = channel

    req = urllib.request.Request(
        webhook,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST"
    )

    with urllib.request.urlopen(req) as r:
        logger.info("Posted to Slack: %s", r.status)

    return {"status": "ok"}
