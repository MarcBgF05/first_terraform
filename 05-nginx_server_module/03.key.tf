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