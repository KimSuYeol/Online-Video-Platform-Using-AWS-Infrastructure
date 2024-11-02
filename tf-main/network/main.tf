resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
    Environment = "Dev"
  }
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(["ap-northeast-2a", "ap-northeast-2b"], count.index)
  map_public_ip_on_launch = true  # 퍼블릭 IP 자동 할당 활성화

  tags = {
    Name = "public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
    Environment = "Dev"
  }
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  availability_zone = element(["ap-northeast-2a", "ap-northeast-2b"], count.index)

  tags = {
    Name = "private-subnet-${count.index + 1}"
    Environment = "Dev"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
    Environment = "Dev"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
    Environment = "Dev"
  }
}

resource "aws_route_table_association" "public" {
  count = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "nat" {
  count         = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gateway-${count.index + 1}"
    Environment = "Dev"
  }
}

resource "aws_eip" "nat" {
  count = 2
}

resource "aws_route_table" "private" {
  count = 2
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table-${count.index + 1}"
    Environment = "Dev"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id  # NAT Gateway ID를 적절히 설정
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id  # 인스턴스 키 사용
}


output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
