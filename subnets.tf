resource "aws_subnet" "webservers" {
  count                   = "${var.public_subnets_count}"
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "${var.cidr_webservers[count.index]}"
  availability_zone       = "${data.aws_availability_zones.azs.names[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "Webserver-${count.index + 1}"
  }
}

resource "aws_subnet" "rds" {
  count                   = "${var.db_sub_count}"
  vpc_id                  = "${aws_vpc.main_vpc.id}"
  cidr_block              = "${var.cidr_rds[count.index]}"
  availability_zone       = "${data.aws_availability_zones.azs.names[count.index]}"
  map_public_ip_on_launch = false

  tags {
    Name = "RDS-${count.index + 1}"
  }
}
