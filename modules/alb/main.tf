resource "aws_lb" "alb" {
  name               = "${terraform.workspace}-alb"
  internal           = var.internal_alb
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group]
  subnets            = var.alb_subnet_id

  enable_deletion_protection = false

   tags = merge(
   {
    Name = "alb.${terraform.workspace}"
  },
  var.tags
  )
}
