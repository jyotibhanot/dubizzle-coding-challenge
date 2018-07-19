# Our default security group to access
# the instances over SSH and HTTP

variable "tag"      {}
variable "vpc_id"   {}
variable "cidr"     {}
variable "region"   {}
variable "image"    {}
variable "key_name" {}
variable "instance_type" {}
variable "jumphost_sg_id" {}
variable "elb_sg_id" {}


variable "subnet_ids" {
    type    = "list"
    default = []
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Security Group for webserver"
  vpc_id      = "${var.vpc_id}"

  # SSH access from bastion
  ingress {
    from_port   	      = 22
    to_port    		      = 22
    protocol   		      = "tcp"
    security_groups 	      = ["${var.jumphost_sg_id}"]
  }

  # HTTP access from anywhere
  ingress {
    from_port                = 80
    to_port    		     = 80
    protocol    	     = "tcp"
    security_groups          = ["${var.elb_sg_id}"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port                  = 443
    to_port                    = 443
    protocol                   = "tcp"
    security_groups            = ["${var.elb_sg_id}"]
  }


  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
      Name          = "${var.tag}-webserver-security-group"
      sre_candidate = "${lower(var.tag)}"
  }
}

resource "aws_instance" "webserver" {
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${var.image}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
  # https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:
  #
  key_name = "${var.key_name}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.webserver_sg.id}"]
  subnet_id              = "${element(var.subnet_ids, count.index)}"
  user_data              = "${file("${path.module}/userdata.sh")}"

  #Instance tags
  tags {
      Name        = "${var.tag}-webserver"
      sre_candidate = "${lower(var.tag)}"
  }
}

output "webserver_instance_id"	{ value = "${aws_instance.webserver.id}" }
output "webserver_sg_id"	{ value = "${aws_security_group.webserver_sg.id}" }
