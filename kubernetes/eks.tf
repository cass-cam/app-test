module "eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "v13.0.0"

  cluster_name                          = "test-app"
  cluster_version                       = 1.17
  subnets                               = ["subnet-08a920fcbc2b575f9", "subnet-07ab4601e1df3df18", "subnet-0da4210f25b3a392b", "subnet-03ae36b967c40e423", "subnet-0a94224dfb7f11919", "subnet-0c8455ee1ec35eac8"]
  vpc_id                                = "vpc-08c89938b596b1fa4"
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
  "arn:aws:iam::264576910958:policy/eks_cluster_autoscaler",
  "arn:aws:iam::264576910958:policy/alb-ingress-controller"
]
  worker_additional_security_group_ids  = ["sg-0bfa4b8e8b945a868", "sg-02224b17a5f84a6dd", "sg-0d081b77e564cf250"]
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
