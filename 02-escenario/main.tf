######### Provider #######
provider "aws" {
  region = "us-east-1"
}

###### Resource
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

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
    Name = "nginx-server"
    Environment = "test"
    Owner = "myself" #
    Team = "DevOps"
    Project = "first_terraform"  
}


}

# 2. Claves SSH - En aws se sube la clave pública, se usa la privada para la conexión.
resource "aws_key_pair" "nginx-server-ssh"{
    key_name   = "nginx-server-ssh"
    public_key = file("nginx-server.key.pub")
    tags = { 
    Name = "nginx-server-ssh"
    Environment = "test"
    Owner = "myself" #
    Team = "DevOps"
    Project = "first_terraform"  
}

}

##### 4. secury group
resource "aws_security_group" "nginx-server-sg" {

    name        = "nginx-server-sg"
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
    Name = "nginx-server-sg"
    Environment = "test"
    Owner = "myself" #
    Team = "DevOps"
    Project = "first_terraform"  
}

}

# Listo para ejecutar. 