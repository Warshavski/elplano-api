# Study plan

[![Build Status](https://travis-ci.com/Warshavski/stdplan-api.svg?branch=develop)](https://travis-ci.com/Warshavski/stdplan-api)
[![Maintainability](https://api.codeclimate.com/v1/badges/24844c90210c54234d4e/maintainability)](https://codeclimate.com/github/Warshavski/stdplan-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/24844c90210c54234d4e/test_coverage)](https://codeclimate.com/github/Warshavski/stdplan-api/test_coverage)

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
git clone https://github.com/warshavski/stdplan-api.git
```

**cd into the directory and install the reqirements.**
```bash
cd stdplan-api && bundle install
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

#### Running tests

Running all tests.
```bash
bundle exec rspec
```

Running a specific test file
```bash
bundle exec rspec ./spec/path/to/file
```
