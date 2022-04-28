#Creando Classic Load Balancer
resource "aws_elb" "app-balancer" {
  name            = "app-balancer"
  subnets         = data.aws_subnets.subredes_publicas.ids
  security_groups = [aws_security_group.elb-rules.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = data.aws_instances.app-server.ids
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "app-servers-web"
  }

  depends_on = [data.aws_instances.app-server, data.aws_subnets.subredes_publicas]
}