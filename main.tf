# Define composite variables for resources
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

module "subnets" {
  source             = "git::https://github.com/everycity/terraform-aws-dynamic-subnets.git"
  availability_zones = "${var.availability_zones}"
  namespace          = "${var.namespace}"
  name               = "${var.name}"
  stage              = "${var.stage}"
  region             = "${var.region}"
  vpc_id             = "${aws_vpc.default.id}"
  cidr_block         = "${aws_vpc.default.cidr_block}"
  igw_id             = "${aws_internet_gateway.default.id}"
  eoigw_id           = "${aws_egress_only_internet_gateway.default.id}"
  delimiter          = "${var.delimiter}"
  attributes         = ["${compact(concat(var.attributes, list("subnets")))}"]
  tags               = "${var.tags}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  assign_generated_ipv6_cidr_block = true
  tags                 = "${module.label.tags}"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags   = "${module.label.tags}"
}

resource "aws_egress_only_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}
