FROM hashicorp/terraform:1.13.3

RUN apk add --no-cache aws-cli bash curl

WORKDIR /workspace

ENTRYPOINT ["terraform"]
