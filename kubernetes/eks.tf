module "eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "v13.0.0"

  cluster_name                          = "test-app"
  cluster_version                       = 1.17
  subnets                               = ["subnet-02e595671bdbd53f2", "subnet-0fa699c2b1efa0e96", "subnet-08897f88d7c268136", "subnet-0a55b2293b35b51b5", "subnet-09d9b9f1e3ca6a7a9", "subnet-0fca21dabff609a90"]
  vpc_id                                = "vpc-0cf6b6bdc98dd851a"
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
  "arn:aws:iam::088190408337:policy/eks_cluster_autoscaler",
  "arn:aws:iam::088190408337:policy/alb-ingress-controller"
]
  worker_additional_security_group_ids  = ["sg-094cb01259fb8351e", "sg-0a805f7c142c79a79", "sg-0bbeeda6a1e977924"]
  map_roles = [
  {
    rolearn  = "arn:aws:iam::088190408337:role/adsoft"
    username = "Admins"
    groups   = ["system:masters"]
  },
]
  map_users = [
  {
    userarn  = "arn:aws:iam::088190408337:user/aeciopires"
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
