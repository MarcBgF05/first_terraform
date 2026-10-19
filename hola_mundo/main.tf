# LocalStack expone sus servicios en el puerto 4566. Como el contenedor de
# Terraform comparte la red de Docker, el hostname correcto es "localstack"
# y no "localhost".
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style = true # Esto obliga a terraform a usar la ruta completa del bucket en lugar de subdominios, lo cual es necesario para LocalStack.

  endpoints {
    s3 = "http://localstack:4566"
  }
}

# Este recurso funciona con el servicio S3 que actualmente habilita
# docker-compose.yml.
resource "aws_s3_bucket" "hola_mundo" {
  bucket = "hola-mundo-local"
}

# Este recurso queda comentado porque requiere EC2 y una AMI válida dentro de
# LocalStack. La AMI de abajo es un ID de ejemplo de AWS real y no existe
# automáticamente en LocalStack.
#
# Para probarlo habría que habilitar EC2 en docker-compose.yml (por ejemplo,
# SERVICES: s3,ec2) y crear/usar una AMI disponible en LocalStack.
# También habría que añadir el endpoint de EC2 al bloque `endpoints`:
#   ec2 = "http://localstack:4566"
#
# resource "aws_instance" "nginx_server" {
#   ami           = "ami-0c55b159cbfafe1f0"
#   instance_type = "t3.micro"
# }
