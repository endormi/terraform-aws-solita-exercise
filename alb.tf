resource "aws_lb" "exercise_alb" {
  name               = "exercise-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.exercise_ec2_sg.id]
  subnets            = "${data.aws_subnet.pub_subnet.*.id}"

  # enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "exercise_alb_logs"
  #   enabled = true
  # }

  tags = {
    Name    = "solita_exercise_alb"
    Project = "solita_exercise_flask_application"
  }
}

resource "aws_lb_listener" "exercise_alb_listener_http" {
  load_balancer_arn = aws_lb.exercise_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.exercise_alb_tg.arn
  }

  tags = {
    Name    = "solita_exercise_alb_listener_http"
    Project = "solita_exercise_flask_application"
  }
}

resource "aws_lb_target_group" "exercise_alb_tg" {
  name     = "exercise-alb-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path    = "/health"
    port    = 3000
    matcher = "200"
    interval = 10
    healthy_threshold = 2
  }

  tags = {
    Name    = "solita_exercise_alb_tg"
    Project = "solita_exercise_flask_application"
  }
}
