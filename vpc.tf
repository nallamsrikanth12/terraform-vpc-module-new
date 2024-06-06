resource "aws_vpc" "main" {
  cidr_block       =  var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.common_tags,
    var.vpc_tags,
        {
            Name = local.resource_name
        }
    )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.aws_internet_gateway_tags,
        {
            Name = local.resource_name
        }
    )
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
        {
            Name = "${local.resource_name}-public-${local.az_names[count.index]}"   
        
        }
    )
             
    
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
        {
            Name = "${local.resource_name}-private-${local.az_names[count.index]}"   
        
        }
    )
             
    
}

resource "aws_subnet" "database_subnet" {
  count = length(var.database_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
        {
            Name = "${local.resource_name}-database-${local.az_names[count.index]}"   
        
        }
    )
             
    
}

resource "aws_db_subnet_group" "aws_db_subnet_group" {
  name       =  local.resource_name
  subnet_ids = aws_subnet.database_subnet[*].id

  tags = merge(
    var.common_tags,
    var.database_subnet_group_tags,
        {
            Name = local.resource_name
        }
    )
}

resource "aws_eip" "elastic_ip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge(
    var.common_tags,
        {
            Name = local.resource_name
        }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.public_route_tags,
        {
            Name = "${local.resource_name}-public-route"
        }
    )
}
 

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.private_route_tags,
        {
            Name = "${local.resource_name}-private-route"
        }
    )
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.database_route_tags,
        {
            Name = "${local.resource_name}-database-route"
        }
    )
}
 

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    =  "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}
 

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    =  "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw.id
}


resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    =  "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw.id
}


resource "aws_route_table_association" "public_association" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnet[*].id , count.index)
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "private_association" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnet[*].id , count.index)
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "database_association" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database_subnet[*].id , count.index)
  route_table_id = aws_route_table.database_route_table.id
}