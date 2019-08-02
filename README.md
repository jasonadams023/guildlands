# guildlands

Tick based web game.

## Local Installation
```
brew install postgresql
gem install rails
bundle install
rake db:setup
```

## Run

### Website
Run the following command from the root of the project:
```
rails server
```

### Ticks
Run the following commands in separate terminals from the root of the project:
```
bundle exec clockwork config/clock.rb
bundle exec rake jobs:work
```