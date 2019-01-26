# README

## Ruby version

2.5.3

## Rails version

5.2.2

## System dependencies

### JavaScript

    $ brew install node
    $ brew install yarn --without-node
    $ bundle
    $ bundle exec rails webpacker:install
    $ brew cask install chromedriver

### puma-dev

    $ brew install puma/puma/puma-dev
    $ sudo puma-dev -setup
    $ puma-dev -install
    $ cd ~/.puma-dev
    $ echo 5000 > ~/.puma-dev/armchair

## Environments

* [Development](http://armchair.test)
* [Production](https://www.armchairdj.com)

## Configuration

## Database creation

## Database initialization

## How to run the test suite

### Slow

    $ bundle exec rspec

### Fast

    $ bundle exec rake parallel:prepare
    $ bundle exec rake parallel:spec

## Services

## Deployment instructions

## Continuous integration with CirlceCI
