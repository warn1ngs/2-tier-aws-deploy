#Variable para crear usuario SSH en cada instancia.
variable "username" {
  type    = string
  default = "admin"
}

#Clave para el usuario SSH a usar en cada instancia.
variable "passwd" {
  type    = string
  default = "$6$rounds=4096$nykXA.RenSsIntnK$T.cI4wKWXZ4V4n2gqr4GsYjB0.uQQtkdb3ixNCXVR2iulknHSGDRWJ4N3EDfs.YNYHkrMJtOKULOPU/NH8BGJ1"
}

#Variables usadas en configurarion de Network
variable "cidr_block_vpc" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Default CIDR Block para dividir en Subredes"
}

#Variable CIDR para todo internet.
variable "cidr_block_inet" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Default CIDR Block para todo Internet"
}

variable "cidr_block_public" {
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
  description = "Default CIDR Block para subred publica"
}

variable "cidr_block_private" {
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
  description = "Default CIDR Block para subred privada"
}

#
variable "block_admin_count" {
  type        = number
  default     = 1 #Agregar cantidad de /32 que se configuren en linea 50
  description = "Cantidad de IPs especificadas en cidr_block_admin"
}

#Si se agregan IPs, subir la cantidad en default de block_admin_count
variable "cidr_block_admin" {
  type    = list(string)
  default = ["0.0.0.0/0"] #Comentar en caso de usar linea 50
  #default     = ["TU-IP/32", "TU-IP/32"]
  description = "Grupo IP de origen para Administracion remota"
}

variable "project_name" {
  description = "Name of the project."
  type        = string
  default     = "proyecto-2-tier"
}