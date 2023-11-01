terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=3.42.0"
    }
  }
}

provider "aws" {
  region  = var.region
}

resource "aws_vpc" "hashidog" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = {
    name = "${var.prefix}-vpc-${var.region}"
    environment = "Production"
  }
}

resource "aws_subnet" "hashidog" {
  vpc_id     = aws_vpc.hashidog.id
  cidr_block = var.subnet_prefix

  tags = {
    name = "${var.prefix}-subnet"
  }
}

resource "aws_security_group" "hashidog" {
  name = "${var.prefix}-security-group"

  vpc_id = aws_vpc.hashidog.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.prefix}-security-group"
  }
}

resource "aws_internet_gateway" "hashidog" {
  vpc_id = aws_vpc.hashidog.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}

resource "aws_route_table" "hashidog" {
  vpc_id = aws_vpc.hashidog.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hashidog.id
  }
}

resource "aws_route_table_association" "hashidog" {
  subnet_id      = aws_subnet.hashidog.id
  route_table_id = aws_route_table.hashidog.id
}



resource "aws_eip" "hashidog" {
  instance = aws_instance.hashidog.id
  vpc      = true
}

resource "aws_eip_association" "hashidog" {
  instance_id   = aws_instance.hashidog.id
  allocation_id = aws_eip.hashidog.id
}

resource "aws_instance" "hashidog" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.hashidog.id
  vpc_security_group_ids      = [aws_security_group.hashidog.id]

  tags = {
    Name = "${var.prefix}-instance"
  }
}


#resource "null_resource" "configure-cat-app" {
#  depends_on = [aws_eip_association.hashidog]
#
#  triggers = {
#    build_number = timestamp()
#  }
#
#  provisioner "file" {
#    source      = "files/"
#    destination = "/home/ubuntu/"
#
#    connection {
#      type        = "ssh"
#      user        = "ubuntu"
#      private_key = tls_private_key.hashidog.private_key_pem
#      host        = aws_eip.hashidog.public_ip
#    }
#  }
#
#}
#
#resource "tls_private_key" "hashidog" {
#  algorithm = "ED25519"
#}
#
#locals {
#  private_key_filename = "${var.prefix}-ssh-key.pem"
#}
#
#resource "aws_key_pair" "hashidog" {
#  key_name   = local.private_key_filename
#  public_key = tls_private_key.hashidog.public_key_openssh
#}
