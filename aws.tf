provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "jagan_security_group" {
  name = "sg_jagan"
  description = "jagan security group."
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "ssh_ingress_access" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.jagan_security_group.id}"
}

resource "aws_security_group_rule" "egress_access" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.jagan_security_group.id}"
}

resource "aws_instance" "jagan_instance" {
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = [ "${aws_security_group.jagan_security_group.id}" ]
  associate_public_ip_address = true
  tags = {
    Name = "jagan-instance"
  }
  key_name = "devops"
  ami = "${var.ami_id}"
  availability_zone = "us-east-1d"
  subnet_id = "${var.subnet_id}"
}

variable "vpc_id" {
        description = "VPC ID to create Security Group"
}

variable "ami_id" {
        description = "Image AMI ID for creating VM"
}

variable "subnet_id" {
        description = "Subnet ID for VM"
}

variable "instance_type" {
        description = "Instance type for creating VM"
}
