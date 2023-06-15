# GoldenKafka

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/Goldbely/golden_kafka/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/Goldbely/golden_kafka/tree/main)

This is just a wrapper around [DeliveryBoy](https://github.com/zendesk/delivery_boy) that ensures any events pushed into Kafka follow Goldbelly's guidelines.

**Note:** ENV vars should still be prefixed using `DELIVERY_BOY_`.

## Installation

Add this line to your application's Gemfile:

```ruby
source "https://rubygems.pkg.github.com/goldbely" do
  gem "golden_kafka"
end
```

Note: make sure you properly [authenticate with Github](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-rubygems-registry#authenticating-with-a-personal-access-token). Or just set:

```
export BUNDLE_RUBYGEMS__PKG__GITHUB__COM=<GH access token>
```

## Usage

Add your first topic to: `config/golden_kafka.yml`

```yml
events:
  com.example.topic:
    dataschema: "v1"
    source: "earth"
    type: "new"
```

You can add any values you want to be used as default values. These can be overridden once the event is created.

Now create and push an event into your new topic:

```ruby
# Init event using template

event = GoldenKafka::Event.new "com.example.topic"
event.data = { key: "value" }
event.time = Time.now
event.type = "created"

# Push event into Kafka
# Important note:
# Starting on v1.0.0, producing and delivering messages requires a serializer class.
GoldenKafka.deliver event, serializer: MySerializer
```

## Serializers
Serializers must implement an initializer that receives the event attributes and a `to_json` method. For example:
```ruby
class MySerializer
  def initialize event_attributes
    # do something
  end

  def to_json( opts = nil )
    # return json representation of event_attributes
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, create a new tag, and push it to Github.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goldbely/golden_kafka. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GoldenKafka project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/goldbely/golden_kafka/blob/master/CODE_OF_CONDUCT.md).
