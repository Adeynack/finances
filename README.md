# README

## Develop

### Initial Setup

```bash
bundle # installs ruby gems
yarn install # installs the JavaScript packages
rails db:create db:migrate # creates the database and loads the schema
rails db:fixtures:load # (optional) creates demo data within the app
```

Look in [`test/fixtures/users.yml`](test/fixtures/users.yml) for a list
of development accounts loaded with the fixtures, to log in the application
in development mode.

### Start a development session

#### Dependencies

Keep this open in a terminal tab.

```bash
docker compose up # starts the dependencies (ex: Redis, PostgreSQL)
```

If the ports clash (ex: you have another project open using those ports), change
the ports in the `.env` file and launch using this command instead.

```bash
docker compose up --env-file .env
```

#### Rails Application

Keep this open in a terminal tab.

```bash
rails serve
```

#### WebPack Development Server

Keep this open in a terminal tab.

```bash
bin/webpack-dev-server
```
