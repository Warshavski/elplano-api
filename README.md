# El Plano

[![Build Status](https://travis-ci.org/Warshavski/elplano-api.svg?branch=develop)](https://travis-ci.org/Warshavski/elplano-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/a5e9ecd7da62ba334087/maintainability)](https://codeclimate.com/github/Warshavski/elplano-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a5e9ecd7da62ba334087/test_coverage)](https://codeclimate.com/github/Warshavski/elplano-api/test_coverage)

Class schedule management application (API)

## Setting up

#### Requirements

- Ruby 2.5.3
- Rails 5.2.2
- Postgresql 9.5+
- Redis 2.8+

#### Installation

**Clone the repo.**
```bash
git clone https://github.com/warshavski/elplano-api.git
```

**cd into the directory and install the reqirements.**
```bash
cd elplano-api && bundle install
```

**set up the database**
```bash
rake db:create 
rake db:migrate 
rake db:seed
```

**Start the server**
```bash
rails s
```

#### Docker
**[install docker-compose](https://docs.docker.com/compose/)**

**set up environment variables**
```bash
mv .env.example .env
```

**cd into the directory and start app via docker-compose.**
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
[api host]/documentation
```
