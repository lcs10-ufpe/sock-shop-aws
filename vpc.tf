resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "test_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
	count = 1

	vpc_id = aws_vpc.main.id
	cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 20)
	availability_zone = var.availability_zones[count.index]
	map_public_ip_on_launch = true
	
	tags = {
		Name = "public_subnet_test_${count.index}"
	}
}

resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "route_igw" {
	vpc_id = aws_vpc.main.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}
}

resource "aws_route_table_association" "route_table_association" {
	count = 1

	route_table_id = aws_route_table.route_igw.id
	subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
}