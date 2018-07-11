resource "aws_subnet" "webservers" {
  count                   = "${var.public_subnets_count}"
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "${var.cidr_webservers[count.index]}"
  availability_zone       = "${var.webservers_azs[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "Webserver-${count.index + 1}"
  }
}
