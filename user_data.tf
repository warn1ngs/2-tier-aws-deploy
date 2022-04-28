#Generando Data para user_data a utilizar en las instancias App Web
data "template_file" "user_data" {
  template = file("./cloud-init.yml")

  vars = {
    username = var.username
    passwd   = var.passwd
  }
}

#Creando Data para user_data a utilizar en las instancias para Bastion host.
data "template_file" "user_data2" {
  template = file("./cloud-init2.yml")

  vars = {
    username = var.username
    passwd   = var.passwd
  }
}