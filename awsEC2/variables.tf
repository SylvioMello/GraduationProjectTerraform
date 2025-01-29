provider "aws" {
  region = "us-east-1"
}

variable "instance_name" {
  type    = string
  default = "live-test-instance"
}

variable "ami_id" {
  type    = string
  default = "ami-07ee04759daf109de" # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
}

variable "instance_type" {
  type    = string
  default = "t4g.medium"
}

variable "key_name" {
  type    = string
  default = "sylviotcc"
}

variable "security_group_ids" {
  type    = list(string)
  default = ["sg-01ce819e8d65269f0"]
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-063299d1358740cb0", "subnet-0e1ef906d9a8dcddd", "subnet-0f6f9a5f0e88f97c8"]
}

variable "inbound_from_port" {
  type    = list(string)
  default = ["80", "80", "80"]
}

variable "inbound_to_port" {
  type    = list(string)
  default = ["80", "80", "80"]
}

variable "inbound_protocol" {
  type    = list(string)
  default = ["TCP", "TCP", "TCP"]
}

variable "inbound_cidr" {
  type    = list(string)
  default = ["10.2.20.0/22", "10.2.28.0/22", "10.2.24.0/22"]
}

variable "outbound_from_port" {
  type    = list(string)
  default = ["32768", "32768", "32768"]
}

variable "outbound_to_port" {
  type    = list(string)
  default = ["61000", "61000", "61000"]
}

variable "outbound_protocol" {
  type    = list(string)
  default = ["TCP", "TCP", "TCP"]
}

variable "outbound_cidr" {
  type    = list(string)
  default = ["10.2.20.0/22", "10.2.28.0/22", "10.2.24.0/22"]
}