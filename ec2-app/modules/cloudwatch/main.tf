resource "aws_cloudwatch_log_group" "app_logs" {
  name = "/aws/lambda/app-logs"
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  log_group_name = aws_cloudwatch_log_group.app_logs.name
  name           = "app-log-stream"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "High-CPU-Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggers when CPU utilization exceeds 80% for 2 consecutive periods"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.alarm_action]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "Low-CPU-Utilization"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Triggers when CPU utilization is below 20% for 2 consecutive periods"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.alarm_action]
}

resource "aws_cloudwatch_metric_alarm" "high_network_in_alarm" {
  alarm_name          = "High-Network-In"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Sum"
  threshold           = 10000000
  alarm_description   = "Triggers when network input exceeds 10 MB/s"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.alarm_action]
}

resource "aws_cloudwatch_metric_alarm" "high_network_out_alarm" {
  alarm_name          = "High-Network-Out"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkOut"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Sum"
  threshold           = 10000000
  alarm_description   = "Triggers when network output exceeds 10 MB/s"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.alarm_action]
}

resource "aws_cloudwatch_metric_alarm" "asg_scale_up_alarm" {
  alarm_name          = "ASG-Scale-Up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "GroupDesiredCapacity"
  namespace           = "AWS/AutoScaling"
  period              = 300
  statistic           = "Average"
  threshold           = 2
  alarm_description   = "Triggers when desired capacity exceeds 2 instances"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.alarm_action]
}

resource "aws_cloudwatch_metric_alarm" "asg_scale_down_alarm" {
  alarm_name          = "ASG-Scale-Down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "GroupDesiredCapacity"
  namespace           = "AWS/AutoScaling"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Triggers when desired capacity is less than 1 instance"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.alarm_action]
}
