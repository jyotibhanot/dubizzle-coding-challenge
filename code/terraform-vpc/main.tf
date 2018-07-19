module "vpc" {
    source      = "./modules/vpc"
    provider    = "${var.provider}"
    name        = "${var.vpc["tag"]}"
    region      = "${var.provider["region"]}"
    cidr        = "${var.vpc["cidr_block"]}"
    zones       = ["${split(",", lookup(var.azs, var.provider["region"]))}"]
    env         = "production"
}

module "public-subnets" {
    source      = "./modules/subnets"
    tag         = "${var.vpc["tag"]}"
    region      = "${var.provider["region"]}"
    cidr        = "${var.vpc["cidr_block"]}"
    subnet_bits = "${var.vpc["subnet_bits"]}"
    zones       = ["${split(",", lookup(var.azs, var.provider["region"]))}"]
    env         = "production"
    type        = "public"
    vpc_id      = "${module.vpc.vpc_id}"
    public_ip   = "true"
}

module "private-subnets" {
    source       = "./modules/subnets"
    tag          = "${var.vpc["tag"]}"
    region       = "${var.provider["region"]}"
    cidr         = "${var.vpc["cidr_block"]}"
    subnet_bits  = "${var.vpc["subnet_bits"]}"
    subnet_start = "1"
    zones        = ["${split(",", lookup(var.azs, var.provider["region"]))}"]
    env          = "production"
    type         = "private"
    vpc_id       = "${module.vpc.vpc_id}"
}

module "nat" {
    source       = "./modules/nat"
    zones        = ["${split(",", lookup(var.azs, var.provider["region"]))}"]
    subnet_ids   = ["${module.public-subnets.subnet_ids}"]
}

module "public-subnets-rt" {
    source       = "./modules/routes/public"
    vpc_id       = "${module.vpc.vpc_id}"
    igw          = "${module.vpc.igw_id}"
    tag          = "${var.vpc["tag"]}"
    zones        = ["${split(",", lookup(var.azs, var.provider["region"]))}"]
    subnet_ids   = ["${module.public-subnets.subnet_ids}"]
}

module "private-subnets-rt" {
    source          = "./modules/routes/private"
    vpc_id          = "${module.vpc.vpc_id}"
    tag             = "${var.vpc["tag"]}"
    zones           = ["${split(",", lookup(var.azs, var.provider["region"]))}"]
    nat_gateway_ids = ["${module.nat.nat_gateway_ids}"]
    subnet_ids      = ["${module.private-subnets.subnet_ids}"]
}

module "bastion" {
    source        = "./modules/bastion"
    tag           = "${var.vpc["tag"]}"
    region        = "${var.provider["region"]}"
    cidr          = "${var.vpc["cidr_block"]}"
    zones         = ["${split(",", lookup(var.azs, var.provider["region"]))}"]
    image         = "${data.aws_ami.ubuntu-xenial.id}"
    key_name      = "${var.key_name}"
    instance_type = "${var.instance_type}"
    vpc_id        = "${module.vpc.vpc_id}"
    subnet_ids    = ["${module.public-subnets.subnet_ids}"]
}

module "elb" {
    source        = "./modules/elb"
    tag           = "${var.vpc["tag"]}"
    vpc_id        = "${module.vpc.vpc_id}"
    subnet_ids    = ["${module.public-subnets.subnet_ids}"]
    instances	  = ["${module.webserver.webserver_instance_id}"]
}


module "webserver" {
    source         = "./modules/webserver"
    tag            = "${var.vpc["tag"]}"
    region         = "${var.provider["region"]}"
    cidr           = "${var.vpc["cidr_block"]}"
    image          = "${data.aws_ami.ubuntu-xenial.id}"
    key_name       = "${var.key_name}"
    instance_type  = "${var.instance_type}"
    vpc_id         = "${module.vpc.vpc_id}"
    subnet_ids     = ["${module.private-subnets.subnet_ids}"]
    jumphost_sg_id = "${module.bastion.bastion_sg_id}" 
    elb_sg_id      = "${module.elb.elb-webelb-sg-id}"
}


output "vpc_id" { value = "${module.vpc.vpc_id}" }
output "igw_id" { value = "${module.vpc.igw_id}" }
output "vpc_cidr" { value = "${module.vpc.vpc_cidr}" }
output "vpc_zones" { value = "${join(",", data.aws_availability_zones.available.names)}" }

output "public_subnets"    { value = "${join(",", module.public-subnets.subnet_ids)}" }
output "private_subnets"   { value = "${join(",", module.private-subnets.subnet_ids)}" }

output "nat_gateway_ids" { value = "${join(",", module.nat.nat_gateway_ids)}" }

output "public_subnets_rt_id"     { value = "${module.public-subnets-rt.public_subnets_rt_id}" }
output "private_subnets_rt_ids"   { value = "${join(",", module.private-subnets-rt.private_subnets_rt_ids)}" }

output "bastion_sg_id"   { value = "${module.bastion.bastion_sg_id}" }
output "bastion_asg_id"  { value = "${module.bastion.bastion_asg_id}" }
output "bastion_lc_id"   { value = "${module.bastion.bastion_lc_id}" }

output "elb-webelb-public-dns" { value = "${module.elb.elb-webelb-public-dns}" }
output "elb-webelb-sg-id" { value = "${module.elb.elb-webelb-sg-id}" }

output "webserver_instance_id" { value = "${module.webserver.webserver_instance_id}" }
output "webserver_sg_id" { value = "${module.webserver.webserver_sg_id}" }
