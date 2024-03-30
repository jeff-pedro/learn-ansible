terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.38.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "wordpress" {
  ami = var.ami
  instance_type = var.type
  key_name = var.key
  security_groups = [ aws_security_group.sg_ssh_access.name ]

  tags = {
    Name = "wordpress"
  }
}

resource "aws_security_group" "sg_ssh_access" {
  name = "ssh-access"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    self = false
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_key_pair" "key_pair" {
  key_name = var.key 
  public_key = file("${var.key}.pub")
}

output "public_ip" {
  value = aws_instance.wordpress.public_ip
}
