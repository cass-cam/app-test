#Aca agregamos las variables correspondientes a la cuenta de AWS donde se va a desplegar el cluster para usar kubernetes

variable "project_name" {
type = string
default = "adidas-app"
}

#nombre con el que se va a crear el cluster 

variable "cluster_name" {
default = "eks-test"
type = "string"
}

#Definicion de la VPC
variable "private_net_cidr" {
description = "10.16.0.0"
default = "/16"
}

#la región que se va a asumir es  North Virginia(us-east-1))
variable "region" {
description = "Region de AWS"
default = "us-east-1"
}

#versión del EKS
variable "eks_version" {
description = "AWS eks_version"
default = "1.18"
}

#identificacion (TAGS)
variable "responsable" {
default = "EKS-test-cai"
}
