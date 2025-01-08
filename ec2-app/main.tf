provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
}

module "autoscaling" {
  source = "./modules/autoscaling"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  alb_target_group_arn = module.alb.target_group_arn
  key_name = module.ec2.key_pair_name
}

module "s3" {
  source = "./modules/s3"
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  asg_name = module.auto_scaling.asg_name
  alarm_action = [aws_sns_topic.alarm_notifications.arn]
}

module "codepipeline" {
  source = "./modules/codepipeline"
  github_oauth_token = var.github_oauth_token
}

module "secrets_manager" {
  source = "./modules/secrets_manager"
}

## SNS Topic for alarm action

resource "aws_sns_topic" "alarm_notifications" {
  name = "alarm-notifications"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
