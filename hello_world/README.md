# Hello World

Este ejercicio crea un bucket S3 dentro de LocalStack. No crea recursos en AWS real.

Ejecuta desde la raíz del repositorio:

```bash
docker compose run --rm terraform -chdir=hello_world init
docker compose run --rm terraform -chdir=hello_world plan
docker compose run --rm terraform -chdir=hello_world apply
```

Para comprobar el bucket:

```bash
docker compose run --rm terraform aws --endpoint-url=http://localstack:4566 s3 ls
```

output "bucket_name" debería mostrar terraform-hello-world al ejecutar:

```bash
docker compose run --rm terraform -chdir=hello_world output
```