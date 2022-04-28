locals {
  name_suffix = "${var.project_name}-${var.deploy_environment}"
}

locals {
  name_suffix2 = "${var.project_name}-bastion-${var.deploy_environment}"
}

#
#locals {
#  ip_privadas = "${slice(aws_instance.bastion-host.*.private_ip, 0, 1)}/32"
#}