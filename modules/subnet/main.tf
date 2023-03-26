locals {
  subnet_list = [cidrsubnets(var.cidr, 8,1)[1],
                  cidrsubnets(var.cidr, 8,2)[1],
                  cidrsubnets(var.cidr, 8,3)[1]
  ]
  pub_subnet = [cidrsubnets(var.cidr, 8,4)[1],
                cidrsubnets(var.cidr, 8,5)[1],
                cidrsubnets(var.cidr, 8,6)[1]
      ] 
}
resource "aws_subnet" "private" {
  vpc_id     = var.id_vpc
  count     = length(local.subnet_list)
  cidr_block = local.subnet_list[count.index]
  map_public_ip_on_launch = false
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = merge(
  {
    Name = "private.${terraform.workspace}-${count.index+1}"
    Environment = terraform.workspace
    tier = "private"
  },
  var.tags
)
}

resource "aws_subnet" "public" {
   vpc_id     = var.id_vpc
   count      = length(local.pub_subnet)
   cidr_block = local.pub_subnet[count.index]
   map_public_ip_on_launch = true
   availability_zone = element(data.aws_availability_zones.available.names, count.index)

   tags = merge(
  {
    Name = "public.${terraform.workspace}-${count.index+1}"
    Environment = terraform.workspace
  },
  var.tags
)
}

############## Route Table ############################
resource "aws_route_table" "main" {
  vpc_id = var.id_vpc

  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = var.nat_gateway_id
    }
  tags = {
    Name = "ngw-${terraform.workspace}"
  }
}

#Collecting IDs of the subnets that have been created.
data "aws_subnet_ids" "private" {
  depends_on = [
    aws_subnet.private
  ]
  filter {
    name   = "tag:tier"
    values = ["private"]
  }
  vpc_id = var.id_vpc
}
#Route table association for nat gateway and the private subnets.
resource "aws_route_table_association" "a" {
  count = length(tolist(aws_subnet.private[*].id))
  depends_on = [
    aws_subnet.private
  ]
  subnet_id      = (tolist(data.aws_subnet_ids.private.ids))[count.index]
  #subnet_id      = length(tolist(aws_subnet.private[*].id))
  route_table_id = aws_route_table.main.id

}

resource "aws_route_table" "igw" {
  vpc_id = var.id_vpc

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = var.gateway_id
    }
}

resource "aws_main_route_table_association" "b" {
  vpc_id = var.id_vpc
  depends_on = [
    aws_subnet.public
  ]
  #subnet_id     = aws_subnet.public[*].id
  route_table_id = aws_route_table.igw.id
}