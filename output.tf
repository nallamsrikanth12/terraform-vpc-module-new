# output "zones_info" {
#     value = data.aws_availability_zones.zone_id
  
# # }


output "vpc_id" {
    value = aws_vpc.main.id
  
}

output "public_subnet_ids" {
    value = aws_subnet.public_subnet[*].id
  
}

output "private_subnet_ids" {
    value = aws_subnet.private_subnet[*].id
  
}

output "database_subnet_ids" {
    value = aws_subnet.database_subnet[*].id
  
}

output "igw_id" {
    value = aws_internet_gateway.gw.id
  
}

output "ngw_id" {
    value = aws_nat_gateway.ngw.id
  
}

output "peering_id" {
  value = aws_vpc_peering_connection.peering_connection.id
}