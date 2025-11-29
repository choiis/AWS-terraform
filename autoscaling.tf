resource "aws_autoscaling_group" "linux_scale_group" {
  name                      = "linux_scale_group"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 120

  vpc_zone_identifier = [
    aws_subnet.private_subnet_1a.id
  ]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.load_balancer_tg.arn
  ]

  tag {
    key                 = "Name"
    value               = "linux_scale_group-ec2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "cpu-scale-out"
  autoscaling_group_name = aws_autoscaling_group.linux_scale_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1       # +1 증가
  cooldown               = 60
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 40        # 40% 이상이면
  alarm_description   = "Scale out when CPU >= 40%"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.linux_scale_group.name
  }
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "cpu-scale-in"
  autoscaling_group_name = aws_autoscaling_group.linux_scale_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1      # -1 감소
  cooldown               = 60
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-utilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 20         # 20% 이하이면
  alarm_description   = "Scale in when CPU <= 20%"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.linux_scale_group.name
  }
}