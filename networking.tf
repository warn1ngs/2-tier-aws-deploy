#Creando VPC con CIDR 10.0.0.0/16
resource "aws_vpc" "vpc-principal" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-principal"
  }
}

#Creando Internet Gateway
resource "aws_internet_gateway" "i-gateway" {
  vpc_id = data.aws_vpc.vpc-principal.id

  tags = {
    Name = "igw-principal"
  }
}

#Creando ruta a internet para VPC Principal
resource "aws_route_table" "iroute-principal" {
  vpc_id = data.aws_vpc.vpc-principal.id

  route {
    cidr_block = var.cidr_block_inet
    gateway_id = aws_internet_gateway.i-gateway.id
  }

  tags = {
    Name = "Regla-Salida"
  }
}

#Creando la subred publica dentro de la VPC - Zona A
resource "aws_subnet" "pub-subred-a" {
  vpc_id            = data.aws_vpc.vpc-principal.id
  cidr_block        = var.environment_instance_settings[var.deploy_environment].subnets[0]
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subred-publica-Zona-A"
    Tier = "Publica"
  }
}

#Creando la subred publica dentro de la VPC - Zona B
resource "aws_subnet" "pub-subred-b" {
  vpc_id            = data.aws_vpc.vpc-principal.id
  cidr_block        = var.environment_instance_settings[var.deploy_environment].subnets[1]
  availability_zone = "us-east-1b"

  tags = {
    Name = "Subred-publica-Zona-B"
    Tier = "Publica"
  }
}

#Creando la subred privada dentro de la VPC - Zona A
resource "aws_subnet" "priv-subred-a" {
  vpc_id                  = data.aws_vpc.vpc-principal.id
  cidr_block              = var.cidr_block_private[0]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Subred-privada-Zona-A"
    Tier = "Privada"
  }
}

#Creando la subred privada dentro de la VPC - Zona B
resource "aws_subnet" "priv-subred-b" {
  vpc_id                  = data.aws_vpc.vpc-principal.id
  cidr_block              = var.cidr_block_private[1]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Subred-privada-Zona-B"
    Tier = "Privada"
  }
}

#Asociando tablas de ruteo con subredes.
resource "aws_route_table_association" "public_routing_table-a" {
  route_table_id = aws_route_table.iroute-principal.id
  subnet_id      = aws_subnet.pub-subred-a.id
}


resource "aws_route_table_association" "public_routing_table-b" {
  route_table_id = aws_route_table.iroute-principal.id
  subnet_id      = aws_subnet.pub-subred-b.id
}


#Creando IP Publicas segun la cantidad de instancias para aplicacion web
resource "aws_eip" "eip_publicas" {
  vpc      = true
  count    = var.environment_instance_settings[var.deploy_environment].count
  instance = element(aws_instance.app-server.*.id, count.index)

  depends_on = [data.aws_instances.app-server, data.aws_vpc.vpc-principal]
}