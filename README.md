# terraform-aws-solita-exercise

![Diagram](diagram/solita_exercise_diagram.png)

Application load balancer has a target group which has a health check. If the health check fails it drains the instances and initializes new instances.

Initialize:

```
terraform init
```

Plan:

```
terraform plan
```

Apply:

```
terraform apply
```

Destroy:

```
terraform destroy
```

**Important notes**:

> Since this task's environment is not meant to be left on. There are things I would've done differently if it was meant to be. I also have other things I would add as well.

- I would use a secret manager for the database credentials (in the real-world) if the database was going to be kept up and not destroyed. Adding secret manager is more of a manual process.
- I would regularly make backups of the DB if it was meant to be running all the time.
- I would create a DNS for the DB, because the underlying IP address changes during failover.
- I would monitor and log.
- I would use a HTTPS, but in this case I used HTTP, because I need a certificate.
- I could use a NAT Gateway and private subnets instead of creating public subnets for ec2 instances. That would be costly though.
- I would use a API Gateway if I had more regions to use.
