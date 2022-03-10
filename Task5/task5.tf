terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.2.0"
    }
  }
}

locals {
  ssh-user     = "ubuntu"
  ssh-key      = "DevOpsSandbox"
  ssh-key-path = "../DevOpsSandbox.pem"
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

# Create VPC
resource "aws_vpc" "task5" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "task5-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "task5" {
  vpc_id                  = aws_vpc.task5.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "task5-subnet"
  }
}

# Create IGW
resource "aws_internet_gateway" "task5" {
  vpc_id = aws_vpc.task5.id

  tags = {
    Name = "task5-igw"
  }
}

# Create routing
resource "aws_route_table" "task5" {
  vpc_id = aws_vpc.task5.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task5.id
  }

  tags = {
    Name = "task5-route"
  }
}

# Define routes
resource "aws_route_table_association" "task5" {
  subnet_id      = aws_subnet.task5.id
  route_table_id = aws_route_table.task5.id
}

# Create Security groups

resource "aws_security_group" "ansible-sg" {
  name   = "task5-ansible-sg"
  vpc_id = aws_vpc.task5.id

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
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

resource "aws_security_group" "wordpress-sg" {
  name   = "task5-wordpress-sg"
  vpc_id = aws_vpc.task5.id

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
  }

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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create IAM policy & role

resource "aws_iam_role_policy" "ansible_policy" {
  name   = "ansible_policy"
  role   = aws_iam_role.ansible_role.id
  policy = file("ansible-policy.json")
}

resource "aws_iam_role" "ansible_role" {
  name = "ansible_role"

  assume_role_policy = file("ansible-role.json")
}

resource "aws_iam_instance_profile" "ansible_profile" {
  name = "ansible_profile"
  role = aws_iam_role.ansible_role.name
}


#  Create instances

resource "aws_instance" "Ansible-VM" {
  ami                  = "ami-0d527b8c289b4af7f"
  instance_type        = "t2.micro"
  key_name             = local.ssh-key
  iam_instance_profile = aws_iam_instance_profile.ansible_profile.name
  tags = {
    Name     = "task5-Ansible",
    Project  = "Task 5"
    Instance = "Ansible"
  }
  subnet_id              = aws_subnet.task5.id
  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  user_data              = file("init-ansible.sh")

  # Upload ansible configs

  # provisioner "local-exec" {
  #   command = "chmod 400 ${local.ssh-key-path}"
  # }

  # provisioner "file" {
  #   source      = "ansible"
  #   destination = "~/"

  #   connection {
  #     type        = "ssh"
  #     user        = local.ssh-user
  #     private_key = file(local.ssh-key-path)
  #     host        = aws_instance.Ansible-VM.public_dns
  #     timeout     = "1m"
  #   }
  # }
}

resource "aws_instance" "Docker-VM1" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"
  key_name      = local.ssh-key
  tags = {
    Name     = "task5-Docker1",
    Project  = "Task 5"
    Instance = "Wordpress"
  }
  subnet_id              = aws_subnet.task5.id
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id]
}

resource "aws_instance" "Docker-VM2" {
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"
  key_name      = local.ssh-key
  tags = {
    Name     = "task5-Docker2",
    Project  = "Task 5"
    Instance = "Wordpress"
  }
  subnet_id              = aws_subnet.task5.id
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id]
}

output "Ansible-address" {
  value = aws_instance.Ansible-VM.public_dns
}

output "Docker1-address" {
  value = aws_instance.Docker-VM1.private_ip
}

output "Docker2-address" {
  value = aws_instance.Docker-VM2.private_ip
}
