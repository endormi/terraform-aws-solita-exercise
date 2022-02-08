resource "aws_autoscaling_group" "exercise_asg" {
  depends_on           = [aws_launch_configuration.alc]

  name                 = "exercise-asg"
  max_size             = "${var.asg_max_size}"
  min_size             = "${var.asg_min_size}"
  desired_capacity     = "${var.asg_desired_capacity}"
  health_check_type    = "ELB"
  force_delete         = true
  launch_configuration = aws_launch_configuration.alc.name
  vpc_zone_identifier  = "${data.aws_subnet.pub_subnet.*.id}"
  target_group_arns    = [aws_lb_target_group.exercise_alb_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.name}_ec2"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_launch_configuration" "alc" {
  name                        = "exercise-alc"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  security_groups             = [aws_security_group.exercise_ec2_sg.id]
  associate_public_ip_address = true
  user_data                   = data.template_file.userdata.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "exercise_cpu_policy" {
  name                   = "exercise-cpu-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.exercise_asg.name
  policy_type            = "SimpleScaling"
}

/*
resource "aws_autoscaling_policy" "exercise_cpu_policy_scaledown" {
  name                   = "exercise-cpu-policy-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.exercise_asg.name
  policy_type            = "SimpleScaling"
}
*/
