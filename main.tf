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

locals {
  ami_id        = "ami-0179a954d94662156" # aws-parallelcluster-3.9.1-ubuntu-2004-lts-hvm-x86_64-202404101335 2024-04-10T13-39-20.292Z
  instance_type = "t2.large"
  key_name      = "sylviotcc"
  subnet_id     = "subnet-06db9c85ba061b6f2" # this can be found at the VPC screen
}

data "aws_security_group" "instance-sg-test" {
  id = "sg-098bf189e29bce82d"
}

resource "aws_instance" "testFree5GC" {
  ami                    = local.ami_id
  instance_type          = local.instance_type
  key_name               = local.key_name
  vpc_security_group_ids = [data.aws_security_group.instance-sg-test.id]

  user_data = <<-EOF
    #cloud-config
    hostname: "testFree5GC"
  EOF

  tags = {
    Name = "testFree5GC"
  }

  subnet_id = local.subnet_id
}

data "aws_ami" "ubuntu_2204" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "owner-id"
    values = ["099720109477"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "srsRAN_K8s" {
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = "t3.medium"
  subnet_id              = local.subnet_id
  key_name               = local.key_name
  vpc_security_group_ids = [data.aws_security_group.instance-sg-test.id]

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
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = "t3.medium"
  subnet_id              = local.subnet_id
  key_name               = local.key_name
  vpc_security_group_ids = [data.aws_security_group.instance-sg-test.id]

  # user_data for K8s installation
  user_data = <<-EOF
    #cloud-config
    hostname: "srsRAN_BareMetal"
  EOF

  tags = {
    Name = "srsRAN_BareMetal"
  }
}