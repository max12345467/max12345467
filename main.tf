# Define el provider de AWS
provider "aws" {
  region = "us-east-1"
}
# Define una instancia EC2 con AMI Ubuntu
resource "aws_instance" "mi_servidor" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
#asocio el sg a la ec2 con la vpc
  vpc_security_group_ids = [aws_security_group.max_allow_8080.id]
  user_data = <<-EOF
            #!/bin/bash
              git clone https://github.com/spring-projects/spring-petclinic.git
              cd spring-petclinic
              ./mvnw package
              java -jar target/*.jar
              EOF
    tags = {
    Name = "Max"
  }
}
#Defin security group
resource "aws_security_group" "max_allow_8080" {
  name        = "max_allow_8080"
  description = "acceso puerto 8080 dese afuera"
  ingress {
    description      = "acceso puerto 8080 desde afuera"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description      = "acceso puerto 8080 desde adentro"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "max_allow_8080"
  }
}