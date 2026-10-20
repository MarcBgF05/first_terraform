
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



