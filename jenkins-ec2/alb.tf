module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 5.0"
  name               = "alb-app"
  load_balancer_type = "application"
  vpc_id             = "vpc-01fc85c2d12a2e0b0"
  subnets            = ["subnet-0297f7d6e0bf5ce1a", "subnet-06025704123cc955b"]
  security_groups    = [aws_security_group.SG_app.id]
  target_groups = [
    {
      name             = "TG-80"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    },
    {
      name             = "TG-8080"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
    }
  ]
  #https_listeners = [
  #  {
  #    port               = 443
  #    protocol           = "HTTPS"
  #    certificate_arn    = "arn:aws:acm:us-east-1:197079866228:certificate/25e63bc3-3819-48b3-87c1-6395c6c53d04"
  #    target_group_index = 0
  #  },
  #  {
  #    port               = 8080
  #    protocol           = "HTTPS"
  #    certificate_arn    = "arn:aws:acm:us-east-1:197079866228:certificate/25e63bc3-3819-48b3-87c1-6395c6c53d04"
  #    target_group_index = 1
  #  }
  #]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = 8080
      protocol           = "HTTP"
      target_group_index = 1
    }
  ]
  tags = {
    Environment = "test-app"
  }
}
#resource "aws_lb_target_group_attachment" "TG-alb8080" {
#  target_group_arn = module.alb.target_group_arns.1
#  target_id        = aws_instance.jenkins_instance-dev.0.id
#  port             = 8080
#}
