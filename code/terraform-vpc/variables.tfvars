vpc = {
    tag         = "jyoti-bhanot"
    cidr_block  = "10.0.0.0/16"
    subnet_bits = "4"
}
key_name        = "ec2key"
instance_type   = "t2.micro"
app = {
    instance_type         = "t2.micro"
    elb_hc_uri            = ""
    listen_port_http      = "80"
    listen_port_https     = "443"
}

