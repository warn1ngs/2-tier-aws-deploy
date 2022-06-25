#Configurando el Proveedor AWS.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.2.0"
    }
  }
}

#Configurando el Auth y Region a usar.
provider "aws" {
  profile = "terraform-priv"
  region  = "us-east-1"
}
