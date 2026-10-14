# Get started with development

The required services are defined in docker-compose.yml, so after having installed docker, run:

```
docker compose up
```

To set up the database (with some seeds)

```
rails db:setup
```

Then start the application. After registering your first user, it is probably easiest to make it an admin via the console.
