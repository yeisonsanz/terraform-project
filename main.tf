#### provider ####
provider "aws" {
  region = "us-east-1"
}

#### resource ####
resource "aws_instance" "nginx-server" {
  ami           = "ami-06a0cd9728546d178"
  instance_type = "t3.micro"

}