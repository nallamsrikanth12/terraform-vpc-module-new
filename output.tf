# output "zones_info" {
#     value = data.aws_availability_zones.zone_id
  
# # }


output "vpc_id" {
    value = aws_vpc.main.id
  
}