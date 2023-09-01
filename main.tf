terraform {
    required_providers {
        aws = {
            source = "480794956627/terraform"
            access_key = AWS_ACCESS_KEY_ID
            secret_key = AWS_SECRET_ACCESS_KEY
            region     = "eu-central-1"
        }
    }
    variable "awsprops" {
        type = "map"
        default = {
            region = "eu-central-1"
            vpc = "vpc-078c9a7ee61fcfeea"
            ami = "ami-04e601abe3e1a910f"
            itype = "t2.micro"
            subnet = "subnet-060d6a838b66de62c"
            publicip = true
            keyname = "myseckey"
            secgroupname = "Red-Team-SG"
        }
    }
//    provider "aws" {
//        region     = "eu-central-1"
//    }
    resource "aws_security_group" "project-sg" {
        name = lookup(var.awsprops, "secgroupname")
        description = lookup(var.awsprops, "secgroupname")
        vpc_id = lookup(var.awsprops, "vpc")

        // To Allow SSH Transport
        ingress {
            from_port = 22
            protocol = "tcp"
            to_port = 22
            cidr_blocks = ["0.0.0.0/0"]
        }

        // To Allow Port 80 Transport
        ingress {
            from_port = 80
            name = "http"
            protocol = tcp
            to_port = 80
            cidr_blocks = ["0.0.0.0/0"]
        }
        // To Allow Port 443 Transport
        ingress {
            from_port = 443
            name = "https"
            protocol = tcp
            to_port = 80
            cidr_blocks = ["0.0.0.0/0"]
        }
        // To Allow Port 3000 Transport
        ingress {
            from_port = 3000
            name = "server"
            protocol = ""
            to_port = 3000
            cidr_blocks = ["0.0.0.0/0"]
        }
        // To Allow Port 3001 Transport
        ingress {
            from_port = 3001
            name = "frontend"
            protocol = ""
            to_port = 3001
            cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
            from_port       = 0
            to_port         = 0
            protocol        = "-1"
            cidr_blocks     = ["0.0.0.0/0"]
        }

        lifecycle {
            create_before_destroy = true
        }
    }
    resource "aws_instance" "appserver" {
        ami = lookup(var.awsprops, "ami")
        instance_type = lookup(var.awsprops, "itype")
        subnet_id = lookup(var.awsprops, "subnet")
        associate_public_ip = lookup(var.awsprops, "publicip")
        keyname = lookup(var.awsprops, "keyname")

        vpc_security_group_ids = [
            aws_security_group.project-sg.id
        ]
        root_block_device {
            delete_on_termination = true
            volume_size = 8
            volume_type = "gp2"
        }
        tags = {
            Name ="SERVER01"
            Environment = "DEV"
            OS = "UBUNTU"
        }

        depends_on = [ aws_security_group.project-sg ]
    }
        resource "aws_instance" "appfront" {
        ami = lookup(var.awsprops, "ami")
        instance_type = lookup(var.awsprops, "itype")
        subnet_id = lookup(var.awsprops, "subnet")
        associate_public_ip = lookup(var.awsprops, "publicip")
        keyname = lookup(var.awsprops, "keyname")

        vpc_security_group_ids = [
            aws_security_group.project-sg.id
        ]
        root_block_device {
            delete_on_termination = true
            volume_size = 8
            volume_type = "gp2"
        }
        tags = {
            Name ="FRONTENT01"
            Environment = "DEV"
            OS = "UBUNTU"
        }

        depends_on = [ aws_security_group.project-sg ]
    }
//    output "ec2instance" {
//        value = aws_instance.*.public_ip
//    }
}
