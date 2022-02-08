resource "aws_cloudwatch_metric_alarm" "cpu_alarm_up" {
  alarm_name          = "cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.exercise_asg.name
  }

  alarm_description = "Monitors EC2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.exercise_cpu_policy.arn]

  tags = {
    Name    = "${var.name}_cloudwatch_metric_cpu_alarm"
    Project = "${var.name}_${var.application}"
  }
}

/*
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_down" {
  alarm_name          = "cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.exercise_asg.name
  }

  alarm_description = "Monitors EC2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.exercise_cpu_policy_scaledown.arn]
}
*/
