output "db_hostname" {
  value = aws_db_instance.rds_db.address
}

output "alb_dns_name" {
  value = aws_lb.exercise_alb.dns_name
}
