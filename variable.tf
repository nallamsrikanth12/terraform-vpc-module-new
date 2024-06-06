# variables  of vpc

variable "cidr_block" {
    default = "10.0.0.0/16"
  
}

variable "enable_dns_hostnames" {
    default = true
  
}

variable "project_name" {
    type = string
  
}


variable "environment" {
    type = string
  
}

variable "vpc_tags" {

    default = {}
  
}

variable "common_tags" {
    type = map
    default = {
        project = "expense"
        environment = "dev"
        terraform = "true"
    }
}

# variables of internet gateway 

variable "aws_internet_gateway_tags" {
    type = map
    default = {}
  
}

# public subnets

variable "public_subnet_cidrs" {
    validation {
      condition =  length(var.public_subnet_cidrs) == 2
      error_message = "please provide the two cidr_blocks"
    }
  
}

variable "public_subnet_tags" {
    default = {}
  
}
# private subnet


variable "private_subnet_cidrs" {
    validation {
      condition =  length(var.private_subnet_cidrs) == 2
      error_message = "please provide the two cidr_blocks"
    }
  
}

variable "private_subnet_tags" {
    default = {}

}

# database subnet

variable "database_subnet_cidrs" {
    validation {
      condition =  length(var.database_subnet_cidrs) == 2
      error_message = "please provide the two cidr_blocks"
    }
  
}

variable "database_subnet_tags" {
    default = {}

}
  

variable "database_subnet_group_tags" {
    default = {}
  
}
  
# nat gateway
variable "aws_nat_gateway_tags" {
    default = {}
  
}

# public route table
variable "public_route_tags" {
  default = {}
}

variable "private_route_tags" {
    default = {}
  
}


variable "database_route_tags" {
    default = {}
  
}


# peering 

variable "is_peering_required" {
    default = false
  
}

variable "acceptor_vpc_id" {
    default = ""
  
}


variable "peerng_connection_tags" {
    default = {}
  
}
