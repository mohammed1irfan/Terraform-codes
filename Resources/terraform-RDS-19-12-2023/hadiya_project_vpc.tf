resource "aws_vpc" "hadiya_project_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true


  tags = {
    Name = "hadiya_project_vpc"
  }
}
