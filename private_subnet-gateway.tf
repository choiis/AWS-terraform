# private_subnet 1 생성
resource "aws_subnet" "private_subnet_1a" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = "10.10.3.0/28"
    availability_zone = "ap-northeast-2c"
    tags = {
        Name = "private_subnet"
    }
}

# NAT elastic ip
resource "aws_eip" "ngw_ip" {
    vpc = true
    depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway 생성
resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.ngw_ip.id
    subnet_id      = aws_subnet.public_subnet_1a.id
    depends_on = [aws_internet_gateway.igw]
    tags = {
        Name = "NAT Gateway"
    }
}

# Private Route Table 생성
resource "aws_route_table" "private_route_table_1" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "Private-Route-1"
    }
}

// route NAT 연결
resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw.id
}

# Subnet Route Private 연결
resource "aws_route_table_association" "private_subnet_1" {
    subnet_id      = aws_subnet.private_subnet_1a.id
    route_table_id = aws_route_table.private_route_table_1.id
}
