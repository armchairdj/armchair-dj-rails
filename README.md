# README

## Ruby version

2.6.3

## Rails version

5.2.3

## System dependencies

### JavaScript: Node, yarn, etc.

    $ brew install node
    $ brew install yarn
    $ bundle
    $ bundle exec rails webpacker:install
    $ brew cask install chromedriver

### Friendly dev URLs: puma-dev

    $ brew install puma/puma/puma-dev
    $ sudo puma-dev -setup
    $ puma-dev -install
    $ cd ~/.puma-dev
    $ echo 5000 > ~/.puma-dev/armchair

### Active Storage image manipulation: vips

    $ brew install vips

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
