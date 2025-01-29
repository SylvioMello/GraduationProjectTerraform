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

module "ec2_instance" {
  source = "./awsEC2"

  instance_name  = "k8s-node"
  ami_id         = "ami-07ee04759daf109de" # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
  instance_type  = "t4g.medium"
  key_name       = "sylviotcc"
  subnet_ids     = ["subnet-063299d1358740cb0", "subnet-0e1ef906d9a8dcddd", "subnet-0f6f9a5f0e88f97c8"]
  instance_count = 3

  inbound_from_port  = ["0", "6443", "22", "30000"]
  inbound_to_port    = ["65000", "6443", "22", "32768"]
  inbound_protocol   = ["TCP", "TCP", "TCP", "TCP"]
  inbound_cidr       = ["172.31.0.0/16", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"]
  outbound_from_port = ["0"]
  outbound_to_port   = ["0"]
  outbound_protocol  = ["-1"]
  outbound_cidr      = ["0.0.0.0/0"]
}