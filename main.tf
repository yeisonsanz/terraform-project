#### provider ####
provider "aws" {
  region = "us-east-1"
}

#### resource ####
resource "aws_instance" "nginx-server" {
  ami           = "ami-06a0cd9728546d178"
  instance_type = "t3.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
  
  key_name = aws_key_pair.nginx-server-ssh.key_name

  vpc_security_group_ids = [
    aws_security_group.nginx-server-sg.id
  ]

  tags = {
    Name       = "nginx-server"
    Enviroment = "test"
    Owner      = "yeisonsanz@outlook.com"
    Team       = "Devops"
    Project    = "webinar"
  }
}

##### SSH ##########
# ssh-keygen -t rsa -b 2048 -f "nginx-server.key"
resource "aws_key_pair" "nginx-server-ssh" {
  key_name = "nginx-server-ssh"
  public_key = file("nginx-server.key.pub") 

   tags = {
    Name       = "nginx-server-ssh"
    Enviroment = "test"
    Owner      = "yeisonsanz@outlook.com"
    Team       = "Devops"
    Project    = "webinar"
  }
}

#### SG #####
resource "aws_security_group" "nginx-server-sg" {
  name = "nginx-server-sg"
  description = "Security group allowing SSH and HTTP access"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
    Name       = "nginx-server-sg"
    Enviroment = "test"
    Owner      = "yeisonsanz@outlook.com"
    Team       = "Devops"
    Project    = "webinar"
  }
}