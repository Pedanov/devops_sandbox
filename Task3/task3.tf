terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.2.0"
    }
  }
}

provider "aws" {
    # All credentials provided via environment variables:
    # AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION
    ##############################################################
    # 
    # These are for manual creds from terraform.tfvars file if provided
    # access_key = "${var.aws_access_key}"
    # secret_key = "${var.aws_secret_key"
    # region = "${var.aws_region}"

}

data "aws_ami" "ubuntu_instance" {
  most_recent = true    
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20211129"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "InstanceOne" {
  ami = data.aws_ami.ubuntu_instance.id # or var.instance_one_ami from variable files
  instance_type = "t2.micro"
  key_name = "DevOpsSandbox"
  tags = {
      Name = "task3-1",
      Project = "Task 3"
    }
  vpc_security_group_ids = [aws_security_group.ubuntu-sg.id]
  user_data = file("ubuntu-script.sh")
}

resource "aws_security_group" "ubuntu-sg" {
  name = "task3-1-sg"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
  }
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks=["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks=["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks=["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks=["0.0.0.0/0"]
  }  
}

data "aws_ami" "centos_instance" {
  most_recent = true    
  owners = ["377253797986"]

  filter {
    name   = "name"
    values = ["aws-nginx"]
  }
}

resource "aws_instance" "InstanceTwo" {
  ami = data.aws_ami.centos_instance.id # or var.instance_two_ami from variable files
  instance_type = "t2.micro"
  key_name = "DevOpsSandbox"
  tags = {
      Name = "task3-2",
      Project = "Task 3"
    }
  vpc_security_group_ids = [aws_security_group.centos-sg.id]
  user_data = file("centos-script.sh")
}

resource "aws_security_group" "centos-sg" {
  name = "task3-2-sg"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks=["${aws_instance.InstanceOne.private_ip}/32"]
  }
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks=["${aws_instance.InstanceOne.private_ip}/32"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks=["${aws_instance.InstanceOne.private_ip}/32"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks=["${aws_instance.InstanceOne.private_ip}/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks=["${aws_instance.InstanceOne.private_ip}/32"]
  }  
}

output "Ubuntu-address" {
  value = aws_instance.InstanceOne.public_dns
}

output "Centos-address" {
  value = aws_instance.InstanceTwo.public_dns
}
