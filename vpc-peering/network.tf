resource "aws_vpc" "seoul_vpc" {
  cidr_block = var.cidr_vpc1

  enable_dns_hostnames	= true

  tags = {
    Name = "seoul-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.seoul_vpc.id

  cidr_block = var.cidr_public_subnet_2

  map_public_ip_on_launch = true

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "seoul-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id = aws_vpc.seoul_vpc.id

  cidr_block = var.cidr_private_subnet_2

  map_public_ip_on_launch = true

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "seoul-public-subnet-3"
  }
}

resource "aws_internet_gateway" "seoul_igw" {

  vpc_id = aws_vpc.seoul_vpc.id

  tags = {
    Name = "seoul-igw"
  }
}

resource "aws_route_table" "seoul_rtb" {
  vpc_id = aws_vpc.seoul_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.seoul_igw.id
  }

  tags = {
    Name = "seoul-routing-table"
  }
}

resource "aws_route_table_association" "seoul_rtb_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.seoul_rtb.id
}

resource "aws_route_table_association" "seoul_rtb_association2" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.seoul_rtb.id
}

resource "aws_vpc" "tokyo_vpc" {
  cidr_block = var.cidr_vpc2
  # 도쿄 리전 provider의 alias
  provider = aws.tokyo

  enable_dns_hostnames	= true

  tags = {
    Name = "tokyo-vpc"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.tokyo_vpc.id

  cidr_block = var.cidr_public_subnet_1

  map_public_ip_on_launch = true

  provider = aws.tokyo

  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "tokyo-public-subnet-2"
  }
}

resource "aws_internet_gateway" "tokyo_igw" {

  vpc_id = aws_vpc.tokyo_vpc.id

  provider = aws.tokyo

  tags = {
    Name = "tokyo-igw"
  }
}

resource "aws_route_table" "tokyo_rtb" {
  vpc_id = aws_vpc.tokyo_vpc.id

  provider = aws.tokyo

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tokyo_igw.id
  }

  tags = {
    Name = "tokyo-routing-table"
  }
}

resource "aws_route_table_association" "tokyo_rtb_association" {
  provider = aws.tokyo
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.tokyo_rtb.id
}

#data "aws_caller_identity" "peer"{
#  provider = aws.seoul
#}

#resource "aws_vpc_peering_connection" "vpc_peering" {
#  vpc_id      = aws_vpc.seoul_vpc.id
#  peer_vpc_id = aws_vpc.tokyo_vpc.id
#  peer_owner_id  = data.aws_caller_identity.peer.account_id
#  auto_accept = true
#}