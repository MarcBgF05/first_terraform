###### tfstate #######
terraform {
  backend "local" {
    path = "terraform.tfstate"
    ###
    # bucket 
    # key
    # region
  }
}


#### MÓDULOS #############
module "nginx_server" {
  source = "./05-nginx_server_module"

  ami_id        = "ami-0440d3b780d96b29d"
  instance_type = "t3.medium"
  server_name   = "nginx-server-dev"
  environment   = "dev"
}
# Por cada módulo se debe inicializar el estado de terraform, para ello se debe ejecutar el comando: terraform init
# Cambiar nombre: nginx-server.key.pub a nginx-server.key-dev.pub

module "nginx_server_qa" {
  source = "./05-nginx_server_module"

  ami_id        = "ami-0440d3b780d96b29d"
  instance_type = "t3.small"
  server_name   = "nginx-server-qa"
  environment   = "qa"
}


################ oUTPUTS #############
# Ouputs / consola: terraform output <nombre de la propiedad>
output "nginx_dev_ip" {
	description = "dirección IP pública de la instancia EC2" 
	value       = module.nginx_server_dev.server_public_ip
}

output "nginx_dev_dns" {
	description = "dirección DNS pública de la instancia EC2" 
	value       = module.nginx_server_dev.server_public_dns
}

# de qa
output "nginx_qa_ip" {
	description = "dirección IP pública de la instancia EC2" 
	value       = module.nginx_server_qa.server_public_ip
}

output "nginx_qa_dns" {
	description = "dirección DNS pública de la instancia EC2" 
	value       = module.nginx_server_qa.server_public_dns
}