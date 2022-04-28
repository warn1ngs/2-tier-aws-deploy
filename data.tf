#Data para zonas de disponibilidad
data "aws_availability_zones" "available" {
  state = "available"
}

#Data para utilizar la ultima version ubuntu para arquitectura x86_64
data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

#Data para filtrar las instancias destinadas a web app
data "aws_instances" "app-server" {

  filter {
    name   = "tag:Type"
    values = ["app"]
  }

  depends_on = [aws_instance.app-server]
}

#Data para filtrar las instancias destinadas a bastion host
data "aws_instances" "bastion-server" {

  filter {
    name   = "tag:Type"
    values = ["bastion"]
  }

  depends_on = [aws_instance.bastion-host]
}

#Data para obtener las subredes publicas
data "aws_subnets" "subredes_publicas" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc-principal.id]
  }

  tags = {
    Tier = "Publica"
  }

  depends_on = [aws_subnet.pub-subred-a, aws_subnet.pub-subred-b]
}

#Data para obtener las subredes privadas
data "aws_subnets" "subredes-privadas" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc-principal.id]
  }

  tags = {
    Tier = "Privada"
  }

  depends_on = [aws_subnet.priv-subred-a, aws_subnet.priv-subred-b]
}

#Data para obtener la ID de la subred publica a
data "aws_subnet" "pub-subred-a" {
  id = aws_subnet.pub-subred-a.id
}

data "aws_subnet" "pub-subred-b" {
  id = aws_subnet.pub-subred-b.id
}

#Data para obtener la ID de la subred publica b
data "aws_security_group" "sg-publico" {
  id = aws_security_group.public-rules.id
}

data "aws_security_group" "sg-bastion" {
  id = aws_security_group.bastion-rules.id
}

data "aws_security_group" "sg-database" {
  id = aws_security_group.db-rules.id
}

#Data para obtener la ID de la VPC
data "aws_vpc" "vpc-principal" {
  id = aws_vpc.vpc-principal.id
}
