#Grupos de seguridad para instancias de aplicaciones web
resource "aws_security_group" "public-rules" {
  name        = "public-rules"
  description = "Reglas para instancias Publicas y ELB"
  vpc_id      = data.aws_vpc.vpc-principal.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = [var.cidr_block_inet]
    description = "Trafico HTTP"
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["10.0.0.0/16"] #Lo ideal aca seria solo desde los servidores Bastions
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.cidr_block_inet]
    description = "Trafico saliente"
  }
}

resource "aws_security_group" "bastion-rules" {
  name        = "bastion-rules"
  description = "Reglas para instancia bastion"
  vpc_id      = data.aws_vpc.vpc-principal.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = slice(var.cidr_block_admin, 0, var.block_admin_count)
    description = "Trafico SSH de Administracion solo desde ciertas IPs"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.cidr_block_inet]
    description = "Trafico saliente"
  }
}

resource "aws_security_group" "db-rules" {
  name        = "db-rules"
  description = "Reglas para DB"
  vpc_id      = data.aws_vpc.vpc-principal.id

  ingress {
    from_port   = 3306
    protocol    = "tcp"
    to_port     = 3306
    cidr_blocks = ["10.0.10.0/24", "10.0.11.0/24"]
    description = "Trafico solo desde Instancias App"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb-rules" {
  name        = "elb-public-rules"
  description = "Reglas para instancias Publicas y ELB"
  vpc_id      = data.aws_vpc.vpc-principal.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = [var.cidr_block_inet]
    description = "Trafico HTTP"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.cidr_block_inet]
    description = "Trafico saliente"
  }
}