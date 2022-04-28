output "elb-address" {
  description = "The DNS name for the Load Balancer"
  value       = aws_elb.app-balancer.dns_name
}

output "web-server-ids" {
  description = "The IDs for each instance."
  value       = aws_instance.app-server.*.id
}

output "web-server-private-ip" {
  description = "The Private IP for each instance."
  value       = aws_instance.app-server.*.private_ip
}

output "web-server-public-ip" {
  description = "The Public IP for each instance."
  value       = aws_instance.app-server.*.public_ip
}

output "bast-server-id" {
  description = "The ID for bastion host."
  value       = aws_instance.bastion-host.*.id
}

output "bast-server-private-ip" {
  description = "The Private IP for bastion host/s."
  value       = aws_instance.bastion-host.*.private_ip
}

output "bast-server-public-ip" {
  description = "The Public IP for bastion host/s."
  value       = aws_instance.bastion-host.*.public_ip
}



#output "test-local" {
#  value = local.ip_privadas
#}

#output "db_master_endpoint" {
#  value       = aws_db_instance.db-master.endpoint
#  description = "The DB endpoint name."
#}
#
#output "db_slave_endpoint" {
#  value       = aws_db_instance.db-slave.address
#  description = "The DB address."
#}