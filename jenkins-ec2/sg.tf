resource "aws_security_group" "SG_app" {
  name   = "SG_app"
  vpc_id = "vpc-0cf6b6bdc98dd851a"
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
