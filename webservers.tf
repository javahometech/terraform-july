resource "aws_instance" "webservers" {
  count                  = "${var.web_servers_count}"
  ami                    = "${var.web_ami}"
  instance_type          = "${var.ec2_instance_type}"
  subnet_id              = "${element(aws_subnet.webservers.*.id,count.index)}"
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
  key_name               = "hari"

  user_data = "${file("./scripts/setup_apache.sh")}"

  tags {
    Name = "Webserver-${count.index+1}"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow http traffic"
  vpc_id      = "${aws_vpc.main_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
