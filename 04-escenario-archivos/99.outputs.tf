# Ouputs / consola: terraform output <nombre de la propiedad>
output "server_public_ip" {
	description = "dirección IP pública de la instancia EC2" 
	value       = aws_instance.example.public_ip
}

output "server_public_dns" {
	description = "dirección DNS pública de la instancia EC2" 
	value       = aws_instance.example.public_dns
}