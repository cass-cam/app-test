module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "ASG-app"

  # Launch configuration
  lc_name = "ASG-app"

  image_id             = "ami-0bcd7ba1832b01f40"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  user_data            = "#!/bin/bash\nsudo yum update -y\nsudo yum -y update\nsudo yum install -y java-1.8.0-openjdk\nsudo yum install -y git\nsudo yum install docker -y\nsudo sudo chkconfig docker on\nsudo yum install wget -y\nsudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo\nsudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key\nsudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key\nsudo yum install -y jenkins\nsudo usermod -a -G docker jenkins\nsudo chkconfig jenkins on\nsudo service docker start\nsudo service jenkins start\ncurl -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl\nchmod +x ./kubectl\nsudo mv ./kubectl /usr/local/bin/kubectl\nyum install aws-cli -y"
  instance_type        = "t3.small"
  security_groups      = [aws_security_group.SG_app.id]

  # Auto scaling group
  asg_name                  = "ASG-app"
  vpc_zone_identifier       = ["subnet-08a920fcbc2b575f9", "subnet-0da4210f25b3a392b"]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  wait_for_capacity_timeout = 0
  target_group_arns         = [module.alb.target_group_arns.1]
}
