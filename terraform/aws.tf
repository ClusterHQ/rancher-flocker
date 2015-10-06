provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

/*
http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/default-vpc.html#default-vpc-basics

x Create a default subnet in each Availability Zone.
x Create an Internet gateway and connect it to your default VPC.
x Create a main route table for your default VPC with a rule that sends all traffic destined for the Internet to the Internet gateway.
x Create a default security group and associate it with your default VPC.
? Create a default network access control list (ACL) and associate it with your default VPC.
x Associate the default DHCP options set for your AWS account with your default VPC.
*/

resource "aws_vpc" "cluster_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    tags {
        Name = "Flocker VPC"
    }
}
resource "aws_subnet" "cluster_subnet" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
    cidr_block = "10.0.0.0/16"
    availability_zone = "${var.aws_availability_zone}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "Flocker subnet"
    }
}
resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"
}
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.cluster_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gateway.id}"
    }
}
resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.cluster_subnet.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_security_group" "cluster_security_group" {
  name = "flocker_rules"
  description = "Allow SSH, HTTP, Flocker APIs"
  vpc_id = "${aws_vpc.cluster_vpc.id}"
  # ssh
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  # http for demo
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  # external flocker api
  ingress {
      from_port = 4523
      to_port = 4523
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  # EVERYTHING (for rancher)
  ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      self = true
  }
  ingress {
      from_port = 0
      to_port = 65535
      protocol = "udp"
      self = true
  }
  # internal flocker-control port
  ingress {
      from_port = 4524
      to_port = 4524
      protocol = "tcp"
      self = true
  }
  # allow outbound traffic
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "master" {
    ami = "${lookup(var.aws_ubuntu_amis, var.aws_region)}"
    instance_type = "${var.aws_instance_type}"
    availability_zone = "${var.aws_availability_zone}"
    vpc_security_group_ids = ["${aws_security_group.cluster_security_group.id}"]
    subnet_id = "${aws_subnet.cluster_subnet.id}"
    key_name = "${var.aws_key_name}"
    tags {
        Name = "Flocker master node"
    }
}
resource "aws_instance" "nodes" {
    ami = "${lookup(var.aws_ubuntu_amis, var.aws_region)}"
    instance_type = "${var.aws_instance_type}"
    availability_zone = "${var.aws_availability_zone}"
    vpc_security_group_ids = ["${aws_security_group.cluster_security_group.id}"]
    subnet_id = "${aws_subnet.cluster_subnet.id}"
    key_name = "${var.aws_key_name}"
    count = "${var.agent_nodes}"
    tags {
        Name = "Flocker agent node"
    }
}
