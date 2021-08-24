# frozen_string_literal: true

require "golden_kafka/errors"
require "golden_kafka/event"
require "golden_kafka/version"
require "delivery_boy"

module GoldenKafka
  class Error < StandardError; end
  class FormatException < Error; end

  class << self
    def configure_delivery_boy
      DeliveryBoy.configure do |cfg|
        yield cfg
      end
    end

    def deliver event, **args, &block
      _validate_event! event

      DeliveryBoy.deliver( event.to_json, topic: event.topic, **args, &block )
    end

    def deliver_async event, **args, &block
      _validate_event! event

      DeliveryBoy.deliver_async( event.to_json, topic: event.topic, **args, &block )
    end

    def deliver_messages
      DeliveryBoy.deliver_messages
    end

    def produce event, **args, &block
      _validate_event! event

      DeliveryBoy.produce( event.to_json, topic: event.topic, **args, &block )
    end

    private

    def _validate_event! event
      # we could also check event is_a Event, but this seems enough for now
      return if event.valid?

      raise FormatException, "event payload must comply with GB guidelines"
    end
  end
end
