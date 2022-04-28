##Creando recurso RDS para base de datos con replica en una segunda instancia.
resource "aws_db_instance" "db-master" {
  instance_class           = var.environment_db_settings[var.deploy_environment].instance_class
  engine                   = var.environment_db_settings[var.deploy_environment].engine
  engine_version           = var.environment_db_settings[var.deploy_environment].engine_version
  db_name                  = var.environment_db_settings[var.deploy_environment].dbname
  username                 = var.environment_db_settings[var.deploy_environment].username
  password                 = var.environment_db_settings[var.deploy_environment].password
  availability_zone        = data.aws_availability_zones.available.names[0]
  db_subnet_group_name     = aws_db_subnet_group.db-server-gp.name
  allocated_storage        = 10
  skip_final_snapshot      = true
  backup_retention_period  = 1
  apply_immediately        = true
  multi_az                 = false
  vpc_security_group_ids   = [data.aws_security_group.sg-database.id]
  delete_automated_backups = true

  tags = {
    Type = "db-master"
  }
}

###Segunda instancia de RDS en AZ diferente.
resource "aws_db_instance" "db-slave" {
  instance_class           = var.environment_db_settings[var.deploy_environment].instance_class
  replicate_source_db      = aws_db_instance.db-master.identifier
  availability_zone        = data.aws_availability_zones.available.names[1]
  vpc_security_group_ids   = [data.aws_security_group.sg-database.id]
  backup_retention_period  = 1
  skip_final_snapshot      = true
  apply_immediately        = true
  delete_automated_backups = true

  tags = {
    Type = "db-slave"
  }
}

#Grupo de Subredes para desplegar las base de datos.
resource "aws_db_subnet_group" "db-server-gp" {
  name       = "db-main"
  subnet_ids = [aws_subnet.priv-subred-a.id, aws_subnet.priv-subred-b.id]
}