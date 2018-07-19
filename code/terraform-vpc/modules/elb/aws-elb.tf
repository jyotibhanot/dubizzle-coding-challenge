variable "tag"      {}
variable "vpc_id"   {}
variable "subnet_ids" {
    type    = "list"
    default = []
}
variable "instances" {
    type    = "list"
    default = []
}

variable "app" {
    default = {
        elb_hc_uri        = ""
        listen_port_http  = "80"
        listen_port_https = "443"
    }
}

/*== ELB ==*/
resource "aws_elb" "webelb" {
  name            = "${var.tag}-elb-webelb"
  subnets         = ["${var.subnet_ids}"]
  security_groups = ["${aws_security_group.elb.id}"]
  listener {
    instance_port     = "${var.app["listen_port_http"]}"
    instance_protocol = "TCP"
    lb_port           = 80
    lb_protocol       = "TCP"
  }
  listener {
    instance_port     = "${var.app["listen_port_https"]}"
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    target              = "TCP:${var.app["listen_port_https"]}${var.app["elb_hc_uri"]}"
    interval            = 10
  }
  instances                   = ["${var.instances}"]

  cross_zone_load_balancing   = true
  idle_timeout                = 400  # set it higher than the conn. timeout of the backend servers
  connection_draining         = true
  connection_draining_timeout = 300
  tags {
    Name = "${var.tag}-elb-webelb"
    Type = "elb"
  }
}

resource "aws_security_group" "elb" {
    name = "${var.tag}-elb"
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = "${var.vpc_id}"
    tags {
        Name        = "${var.tag}-elb-security-group"
        sre_candidate = "${var.tag}"
    }
}

output "elb-webelb-public-dns" { value = "${aws_elb.webelb.dns_name}" }
output "elb-webelb-sg-id" { value = "${aws_security_group.elb.id}" }
