# Create a new load balancer
resource "aws_elb" "my_vpc_elb" {
  name            = "my-vpc-elb"
  subnets         = ["${aws_subnet.webservers.*.id}"]
  security_groups = ["${aws_security_group.elb_sg.id}"]
  instances       = ["${aws_instance.webservers.*.id}"]

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
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "my_vpc_elb"
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "Allow all inbound http traffic"
  vpc_id      = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
