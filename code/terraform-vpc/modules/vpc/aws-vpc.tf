variable "name"   { default = "vpc" }
variable "region" {}
variable "cidr"   {}
variable "zones" {
    type = "list"
    default = []
}
variable "env" { default = "production" }
variable "provider" {
    type    = "map"
    default = {
        access_key = "unknown"
        secret_key = "unknown"
        region     = "unknown"
    }
}

/*=== VPC AND GATEWAYS ===*/
resource "aws_vpc" "environment" {
    cidr_block           = "${var.cidr}"
    enable_dns_support   = true
    enable_dns_hostnames = true 
    tags {
        Name        = "VPC-${var.name}"
        sre_candidate = "${lower(var.name)}"
    }
}

resource "aws_internet_gateway" "environment" {
    vpc_id = "${aws_vpc.environment.id}"
    tags {
        Name        = "${var.name}-internet-gateway"
        sre_candidate = "${lower(var.name)}"
    }
}


resource "aws_vpc_dhcp_options" "environment" {
    domain_name         = "${var.provider["region"]}.compute.internal ${lower(var.name)} consul"
    domain_name_servers = ["169.254.169.253", "AmazonProvidedDNS"]
    tags {
        Name        = "${var.name}-dhcp-options"
        sre_candidate = "${lower(var.name)}"
    }
}

resource "aws_vpc_dhcp_options_association" "environment" {
    vpc_id          = "${aws_vpc.environment.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.environment.id}"
}

output "vpc_id" { value = "${aws_vpc.environment.id}" }
output "igw_id" { value = "${aws_internet_gateway.environment.id}" }
output "vpc_cidr" { value = "${aws_vpc.environment.cidr_block}" }
