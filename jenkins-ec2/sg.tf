resource "aws_security_group" "SG_app" {
  name   = "SG_app"
  vpc_id = "vpc-01fc85c2d12a2e0b0"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
