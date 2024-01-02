resource "aws_internet_gateway" "igw_hadiya_project" {
  vpc_id = aws_vpc.hadiya_project_vpc.id

  tags = {
    Name = "igw-hadiya-project"
  }
}
