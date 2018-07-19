/*=== DATA SOURCES ===*/
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_ami" "ubuntu-trusty" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
data "aws_ami" "ubuntu-xenial" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

/*=== VARIABLES ===*/
variable "provider" {
    type    = "map"
    default = {
        access_key = "unknown"
        secret_key = "unknown"
        region     = "unknown"
    }
}

provider "aws" {
    access_key = "${var.provider["access_key"]}"
    secret_key = "${var.provider["secret_key"]}"
    region     = "${var.provider["region"]}"
}

variable "vpc" {
    type    = "map"
    default = {
        "id"          = "unknown"
        "tag"         = "unknown"
        "cidr_block"  = "unknown"
        "subnet_bits" = "unknown"
        "owner_id"    = "unknown"
        "sns_topic"   = "unknown"
    }
}

variable "azs" {
    type    = "map"
    default = {
        "ap-southeast-2" = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
        "eu-west-1"      = "eu-west-1a,eu-west-1b"
        "us-west-1"      = "us-west-1b,us-west-1c"
        "us-west-2"      = "us-west-2a,us-west-2b,us-west-2c"
        "us-east-1"      = "us-east-1c,us-west-1d,us-west-1e"
        "ap-southeast-1" = "ap-southeast-1a,ap-southeast-1b"
    }
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_name" {
    default = "unknown"
}
