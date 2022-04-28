#Variable por la cual se establece sobre que entorno se debe desplegar la infraestructura.
variable "deploy_environment" {
  default = "DEV"
}

#Variable inicial de settings para instancias de aplicacion web.
variable "environment_instance_settings" {
  type = map(object({ instance_type = string, monitoring = bool, count = number, bastion = bool, b_count = number, subnets = list(string) }))
  default = {
    "DEV" = {
      instance_type = "t2.micro",
      monitoring    = false,
      count         = 2
      bastion       = true
      b_count       = 1
      subnets       = ["10.0.10.0/24", "10.0.11.0/24"]
    },
    "QA" = {
      instance_type = "t2.micro",
      monitoring    = false,
      count         = 1
      bastion       = true
      b_count       = 1
      subnets       = ["10.0.12.0/24", "10.0.13.0/24"]
    },
    "STATE" = {
      instance_type = "t2.micro",
      monitoring    = false,
      count         = 2
      bastion       = true
      b_count       = 1
      subnets       = ["10.0.14.0/24", "10.0.15.0/24"]
    },
    "PROD" = {
      instance_type = "t2.micro",
      monitoring    = true,
      count         = 4
      bastion       = true
      b_count       = 2 #Desplegando 2 servidores bastions en cada zona para produccion.
      subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
    },

    "BASTION" = {
      instance_type = "t2.micro",
      monitoring    = false,
      count         = 1
      bastion       = false
      b_count       = 0
      subnets       = ["10.0.10.0/24", "10.0.11.0/24"]
    }
  }
}

#Variable inicial de settings para instancias de base de datos.
variable "environment_db_settings" {
  type = map(object({ instance_class = string, engine = string, engine_version = number, dbname = string, username = string, password = string }))
  default = {
    "DEV" = {
      instance_class = "db.t3.micro"
      engine         = "mysql"
      engine_version = "5.7"
      dbname         = "dbserver"
      username       = "dbuser"
      password       = "dbpass1234"
    }
    "PROD" = {
      instance_class = "db.t3.micro"
      engine         = "mysql"
      engine_version = "5.7"
      dbname         = "dbserver"
      username       = "dbuser"
      password       = "dbpass1234"
    }
  }
}