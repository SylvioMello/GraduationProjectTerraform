terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

locals {
  inbound_from_port  = ["0", "6443", "22", "30000"]
  inbound_to_port    = ["65000", "6443", "22", "32768"]
  inbound_protocol   = ["TCP", "TCP", "TCP", "TCP"]
  inbound_cidr       = ["172.31.0.0/16", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"]
  outbound_from_port = ["0"]
  outbound_to_port   = ["0"]
  outbound_protocol  = ["-1"]
  outbound_cidr      = ["0.0.0.0/0"]
  key_name           = "sylviotcc"
  subnet_id          = "subnet-06db9c85ba061b6f2" # this can be found at the VPC screen
}

resource "aws_security_group" "instance-sg" {
  name        = "Ks Node SG"
  description = "SG for Kubeadm Nodes"

  dynamic "ingress" {
    for_each = toset(range(length(local.inbound_from_port)))
    content {
      from_port   = local.inbound_from_port[ingress.key]
      to_port     = local.inbound_to_port[ingress.key]
      protocol    = local.inbound_protocol[ingress.key]
      cidr_blocks = [local.inbound_cidr[ingress.key]]
    }
  }

  dynamic "egress" {
    for_each = toset(range(length(local.outbound_from_port)))
    content {
      from_port   = local.outbound_from_port[egress.key]
      to_port     = local.outbound_to_port[egress.key]
      protocol    = local.outbound_protocol[egress.key]
      cidr_blocks = [local.outbound_cidr[egress.key]]
    }
  }
}

resource "aws_instance" "srsRAN_K8s" {
  ami                    = "ami-0e1bed4f06a3b463d" #ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*
  instance_type          = "t3.xlarge"
  subnet_id              = local.subnet_id
  key_name               = local.key_name
  vpc_security_group_ids = [aws_security_group.instance-sg.id]

  # user_data for K8s installation
  user_data = <<-EOF
    #cloud-config
    hostname: "srsRAN_K8s"
  EOF

  tags = {
    Name = "srsRAN_K8s"
  }
}

resource "aws_instance" "srsRAN_BareMetal" {
  ami                    = "ami-0e1bed4f06a3b463d" #ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*
  instance_type          = "t3.large"
  subnet_id              = local.subnet_id
  key_name               = local.key_name
  vpc_security_group_ids = [aws_security_group.instance-sg.id]

  # user_data for K8s installation
  user_data = <<-EOF
    #cloud-config
    hostname: "srsRAN_BareMetal"
  EOF

  tags = {
    Name = "srsRAN_BareMetal"
  }
}