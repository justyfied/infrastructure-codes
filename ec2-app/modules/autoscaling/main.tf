resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = var.subnet_ids
  launch_template {
    launch_template_name = aws_launch_template.ec2_launch_template.name
    version             = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  wait_for_capacity_timeout  = "0"
  target_group_arns         = [var.alb_target_group_arn]

  tag {
    key                 = "Name"
    value               = "AppServer"
    propagate_at_launch = true
  }


  notification {
    topic_arn = aws_sns_topic.alarm_notifications.arn
    topic_action = "autoscaling:EC2_INSTANCE_LAUNCH"
    topic_action = "autoscaling:EC2_INSTANCE_TERMINATE"
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  estimated_instance_warmup = 300
  autoscaling_group_name   = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  estimated_instance_warmup = 300
  autoscaling_group_name   = aws_autoscaling_group.asg.name
}
