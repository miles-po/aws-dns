# aws-dns
DNS service for use with dockerized Localstack Pro.

In your `docker-compose.yml` file:

```yml
services:

  ...

  localstack:
    image: localstack/localstack
    container_name: my_localstack
    ports:
      - "4567-4607:4567-4607"
      - "9080:8080"
    environment:
      - SERVICES=serverless
      - DATA_DIR=/tmp/localstack/data
    env_file: ./.env
    volumes:
      - "./.localstack:/tmp/localstack"
      - "/var/run/docker.sock:/var/run/docker.sock"
    networks:
      my_network:
        ipv4_address: 10.5.0.2

  localstack-dns:
    build:
      context: $PATH_TO_AWS_DNS/aws-dns
    image: po/aws-dns
    container_name: my_aws-dns
    networks:
      my_network:
        ipv4_address: 10.5.0.3

networks:
  my_network:
    driver: bridge
    ipam:
      config:
        - subnet: 10.5.0.0/16
          gateway: 10.5.0.1

```
Currently the subnet is hard-coded because of the DNS server config.
It should be converted to an environment variable.

All services that call AWS with the SDK should include the following:
```yml
    environment:
      - NODE_TLS_REJECT_UNAUTHORIZED=0
    networks:
      my_network:
    dns: 10.5.0.3
    depends_on:
      localstack:

```

