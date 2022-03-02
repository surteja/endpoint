resource "aws_vpc" "main" {
  # The CIDR block for the VPC.
  cidr_block = "192.168.0.0/16"

  # Makes your instances shared on the host.
  instance_tenancy = "default"

  # Required for EKS. Enable/disable DNS support in the VPC.
  enable_dns_support = true

  # Required for EKS. Enable/disable DNS hostnames in the VPC.
  enable_dns_hostnames = true

  # Enable/disable ClassicLink for the VPC.
  enable_classiclink = false

  # Enable/disable ClassicLink DNS Support for the VPC.
  enable_classiclink_dns_support = false

  # Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC.
  assign_generated_ipv6_cidr_block = false

  # A map of tags to assign to the resource.
  tags = {
    Name            = "${var.vpc_resources_name}-VPC"
  }
}


resource "aws_subnet" "public" {
  # The VPC ID.
  vpc_id = aws_vpc.main.id

  # Avaliability zone
  availability_zone = "us-east-1a"

  # The CIDR block for the subnet.
  cidr_block = "192.168.32.0/19"

  # Required for EKS. Instances launched into the subnet should be assigned a public IP address.
  map_public_ip_on_launch = true

  # A map of tags to assign to the resource.
  tags = {
    Name                        = "${var.vpc_resources_name}-subnet-public-2a"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
    
  }
}
