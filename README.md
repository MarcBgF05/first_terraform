# Ejercicios de Terraform

Entorno de aprendizaje para ejecutar Terraform dentro de Docker y practicar con servicios AWS simulados por LocalStack. Las credenciales usadas son de prueba y no se realizan llamadas a AWS real.

## Requisitos

- Docker Desktop con Docker Compose v2 (`docker compose version`)
- Git (opcional)

## Iniciar el entorno

Desde la raíz del repositorio, construye la imagen de Terraform e inicia LocalStack:

```bash
docker compose build
docker compose up -d localstack
```

LocalStack quedará disponible en `http://localhost:4566`. El contenedor de Terraform se ejecuta bajo demanda y monta esta carpeta en `/workspace`.

En PowerShell, los mismos comandos funcionan igual. Para detener el entorno:

```bash
docker compose down
```

Para detenerlo y borrar también los datos persistidos de LocalStack:

```bash
docker compose down -v
```

## Primer ejercicio: hello world

El ejercicio está en [`hello_world/main.tf`](hello_world/main.tf) y crea un bucket S3 dentro de LocalStack.

```bash
docker compose run --rm terraform -chdir=hello_world init
docker compose run --rm terraform -chdir=hello_world fmt
docker compose run --rm terraform -chdir=hello_world validate
docker compose run --rm terraform -chdir=hello_world plan
docker compose run --rm terraform -chdir=hello_world apply
```

Cuando Terraform pida confirmación, escribe `yes`. También puedes usar `apply -auto-approve`.

Comprueba el resultado con AWS CLI apuntando a LocalStack:

```bash
docker compose run --rm terraform aws --endpoint-url=http://localstack:4566 s3 ls
```

Finalmente, elimina el recurso creado por el ejercicio:

```bash
docker compose run --rm terraform -chdir=hello_world destroy
```

## Estructura

```text
.
├── Dockerfile
├── docker-compose.yml
└── hello_world/
    ├── main.tf
    └── README.md
```

Cada ejercicio nuevo puede vivir en su propia carpeta y ejecutarse con `-chdir=nombre_del_ejercicio`.

## Comandos extra.
LocalStack simula servicios AWS dentro del contenedor localstack; los recursos como buckets S3 no aparecen como contenedores separados en Docker.

Ver el estado de Terraform:
```bash
docker compose run --rm terraform -chdir=nombre_de_la_carpeta state list
```

Ver detalles del bucket registrado en Terraform:
```bash
docker compose run --rm terraform -chdir=nombre_de_la_carpeta state show aws_s3_bucket.nombre_de_la_carpeta
```         

Listar buckets directamente en LocalStack usando AWS CLI
```bash
docker compose run --rm --entrypoint aws terraform `
  --endpoint-url=http://localstack:4566 s3 ls
```

Ver los objetos dentro del bucket:
```bash
docker compose run --rm --entrypoint aws terraform `
  --endpoint-url=http://localstack:4566 s3 ls s3://nombre-carpeta-local
```