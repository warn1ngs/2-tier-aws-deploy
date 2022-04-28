#Creando instancias para Web App, dependiendo del entorno de trabajo.
resource "aws_instance" "app-server" {
  count = var.environment_instance_settings[var.deploy_environment].count

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.environment_instance_settings[var.deploy_environment].instance_type
  monitoring             = var.environment_instance_settings[var.deploy_environment].monitoring
  subnet_id              = tolist(data.aws_subnets.subredes_publicas.ids)[count.index % length(data.aws_subnets.subredes_publicas.ids)]
  vpc_security_group_ids = [data.aws_security_group.sg-publico.id]

  tags = {
    Name        = "${local.name_suffix}-${count.index}"
    Environment = var.deploy_environment
    Type        = "app"
  }

  depends_on = [data.aws_subnets.subredes_publicas]
  user_data  = data.template_file.user_data.rendered

}

#Creando Instancias para Bastion Host, cantidad depende del entorno de trabajo.
resource "aws_instance" "bastion-host" {
  count = var.environment_instance_settings[var.deploy_environment].bastion != false ? var.environment_instance_settings[var.deploy_environment].b_count : 0

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.environment_instance_settings.BASTION.instance_type
  monitoring                  = var.environment_instance_settings.BASTION.monitoring
  subnet_id                   = tolist(data.aws_subnets.subredes_publicas.ids)[count.index % length(data.aws_subnets.subredes_publicas.ids)]
  vpc_security_group_ids      = [data.aws_security_group.sg-bastion.id]
  associate_public_ip_address = true

  tags = {
    Name = "${local.name_suffix2}-${count.index}"
    Type = "bastion"
  }

  depends_on = [data.aws_subnets.subredes_publicas]
  user_data  = data.template_file.user_data2.rendered
}