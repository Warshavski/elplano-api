# El Plano

[![Build Status](https://travis-ci.org/Warshavski/elplano-api.svg?branch=develop)](https://travis-ci.org/Warshavski/elplano-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/a5e9ecd7da62ba334087/maintainability)](https://codeclimate.com/github/Warshavski/elplano-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a5e9ecd7da62ba334087/test_coverage)](https://codeclimate.com/github/Warshavski/elplano-api/test_coverage)

Class schedule management application (API)

## Introduction

El Plano is a self hosted class schedule management REST API server built with Rails and based on [JSON API](https://jsonapi.org/) specification.

## Setting up

#### Requirements

- Ruby 2.6.5
- Rails 5.2.2+
- Postgresql 9.5+
- Redis 2.8+

#### Installation

Clone the repo.
```bash
git clone https://github.com/warshavski/elplano-api.git
```

Move into the project directory and install the requirements.
```bash
cd elplano-api && bundle install
```

Create and configure .env file.
```bash
mv .env.example .env
```

Set up the database.
```bash
rake db:create 
rake db:migrate 
rake db:seed
```

Start the application development server.
```bash
rails s
```

#### Docker
Install [docker-compose](https://docs.docker.com/compose/).

Create and configure .env file.
```bash
mv .env.example .env
```

Move into the project directory and start app via docker-compose.
```bash
cd elplano-api && docker-compose up -d
```

#### Running tests

Running all tests.
```bash
bundle exec rspec
```

Running a specific test file.
```bash
bundle exec rspec ./spec/path/to/file
```

#### Documentation

Generate/Update API documentation.
```bash
bundle exec rspec spec/acceptance --format RspecApiDocumentation::ApiFormatter
```

See API documentation.
```bash
/documentation
```
