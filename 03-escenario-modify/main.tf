#### Definición de variables
####### Variables #######

variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  default     = "ami-0440d3b780d96b29d"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t3.micro"
}

variable "server_name" {
  description = "Nombre del servidor web"
  default     = "nginx-server"
}

variable "environment" {
  description = "Ambiente de la aplicación"
  default     = "test"
}



######### Provider #######
provider "aws" {
  region = "us-east-1"
}

###### Resource
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type

# 1. Instalación de Nginx
    user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y nginx
                sudo systemctl enable nginx
                sudo systemctl start nginx
                EOF


### 3.  creando la instancia de EC2 con la clave SSH.
    key_name = aws_key_pair.nginx-server-ssh.key_name  # <>.nombre_del_recurso.propiedad 

# Parte del security group - security group creado en el paso 4. Se asocia a la instancia de EC2. Le asignamos el ID.
    vpc_security_group_ids = [aws_security_group.nginx-server-sg.id]  #

# 5.1 Agregando un tag a la instancia de EC2
tags = { 
    Name = var.server_name
    Environment = var.environment
    Owner = "myself" #
    Team = "DevOps"
    Project = "first_terraform"  
}


}

# 2. Claves SSH - En aws se sube la clave pública, se usa la privada para la conexión. 
# Cada instancia debería tener su propia clave SSH. Se puede crear una variable para el nombre de la clave y otra para el nombre del servidor.
resource "aws_key_pair" "nginx-server-ssh"{
    key_name   = "${var.server_name}-ssh"
    public_key = file("${var.server_name}.key.pub")
    tags = { 
    Name = "${var.server_name}-ssh"
    Environment = "test"
    Owner = "myself" #
    Team = "DevOps"
    Project = "first_terraform"  
}

}

##### 4. secury group
resource "aws_security_group" "nginx-server-sg" {

    name        = "${var.server_name}-sg"
    description = "Security group allowing SSH and HTTP access"

    # reglas de entrada
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

    # Una regla de salida que permite todo el tráfico saliente
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { 
    Name = "${var.server_name}-sg"
    Environment = var.environment
    Owner = "myself" #
    Team = "DevOps"
    Project = "first_terraform"  
}

}

# Listo para ejecutar. 

# Ouputs / consola: terraform output <nombre de la propiedad>
output "server_public_ip" {
	description = "dirección IP pública de la instancia EC2" 
	value       = aws_instance.example.public_ip
}

output "server_public_dns" {
	description = "dirección DNS pública de la instancia EC2" 
	value       = aws_instance.example.public_dns
}

# Probando la key SSH
# ssh -i nginx-server.key ec2-user@<IP_PÚBLICA_DE_LA_INSTANCIA> 
# ssh ec2-user@<IP_PÚBLICA_DE_LA_INSTANCIA> -i nginx-server.key