module "eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "v13.0.0"

  cluster_name                          = "test-app"
  cluster_version                       = 1.17
  subnets                               = ["subnet-094e45046cc6418f6", "subnet-0297f7d6e0bf5ce1a", "subnet-00255d0f56a619ae3", "subnet-06025704123cc955b", "subnet-096d3ca72c63ece4d", "subnet-0c3281f4e7f4a05d8"]
  vpc_id                                = "vpc-01fc85c2d12a2e0b0"
  cluster_endpoint_public_access        = true
  cluster_endpoint_public_access_cidrs  = ["0.0.0.0/0"]
  cluster_endpoint_private_access       = true
  cluster_endpoint_private_access_cidrs = ["0.0.0.0/0"]
  write_kubeconfig                      = false
  workers_additional_policies           = [
  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
  "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
  "arn:aws:iam::2645769109588:policy/eks_cluster_autoscaler",
  "arn:aws:iam::2645769109588:policy/alb-ingress-controller"
]
  worker_additional_security_group_ids  = ["sg-0f81a4396b5b2772c", "sg-00346365b24b4befa", "sg-070f86f87ffcf544a"]
  map_roles = [
  {
    rolearn  = "arn:aws:iam::264576910958:role/adsoft"
    username = "Admins"
    groups   = ["system:masters"]
  },
]
  map_users = [
  {
    userarn  = "arn:aws:iam::264576910958:user/aeciopires"
    username = "aeciopires"
    groups   = ["system:masters"]
  },
]
  worker_groups_launch_template = [
    {
      name                                     = "test-ec2-lc"
      override_instance_types                  = ["t3.medium", "t3.small"]
      on_demand_percentage_above_base_capacity = 50
      asg_min_size                             = 6
      asg_max_size                             = 6
      asg_desired_capacity                     = 6
      autoscaling_enabled                      = true
      kubelet_extra_args                       = "--node-labels=node.kubernetes.io/lifecycle=spot"
      suspended_processes                      = ["AZRebalance"]
      root_volume_size                         = 20
    },
  ]
kubeconfig_aws_authenticator_command         = "aws"
  kubeconfig_aws_authenticator_command_args    = ["eks", "update-kubeconfig"]
  kubeconfig_aws_authenticator_additional_args = ["--name", var.cluster_name, "--alias", var.cluster_name]
  kubeconfig_aws_authenticator_env_variables   = {
    AWS_PROFILE        = "default"
    AWS_DEFAULT_REGION = "us-east-1"
  }

}
resource "aws_ecr_repository" "app-test-ecr" {
  name                 = "app-test-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
