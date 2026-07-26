Configure docker for RabbitMQ

```batch
mkdir -p ~/docker/rabbitmq

cp /mnt/e/repository/java-reactive-cookbook-for-restaurant/docker/.* ~/docker/rabbitmq
cp /mnt/e/repository/java-reactive-cookbook-for-restaurant/docker/* ~/docker/rabbitmq

docker compose up -d
docker ps
docker compose down

```

Create modules

1. order
1. kitchen
1. inventory
1. menu
1. notification
1. employee

```batch
cd backend
mvn archetype:generate -DgroupId=com.felipebarrera -DartifactId=<module> -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false -DoutputDirectory=module
```

mvn archetype:generate -DgroupId=com.felipebarrera -DartifactId=common -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

## Code Style

Extensions

Red Hat XML

Used Visual Studio Code Settings JSON

```batch
{
  "[xml]": {
    "editor.defaultFormatter": "redhat.vscode-xml",
    "editor.tabSize": 2
  },
  ...
  "xml.format.joinComments": true,
  "xml.format.maxLineWidth": 120,
  "[java]": {
    "editor.defaultFormatter": "redhat.java",
    "editor.tabSize": 4
  },
}

```
