# frozen_string_literal: true
require "golden_kafka/errors"
require "golden_kafka/template_factory"
require "active_model"
require "json"

module GoldenKafka
  class Event
    include ActiveModel::Model

    attr_accessor :id, :data, :dataschema, :source, :subject, :time, :type
    attr_reader :topic

    validates :id,
      :source,
      :type,
      presence: true

    # TODO: Until we can work on code-generators,
    # we receive both the serializer and the topic name
    def initialize topic, serializer, attrs = {}
      @topic = topic
      @serializer = serializer

      # find template and use it as default values
      super _template.merge( attrs )

      # auto gen id if needed
      self.id ||= SecureRandom.uuid
    end

    def as_json
      {
        id: id,
        data: data,
        dataschema: dataschema,
        source: source,
        subject: subject,
        time: time,
        type: type,
      }
    end

    # Delegate method to provided class
    def to_json _options = nil
      @serializer.new( as_json ).to_json
    end

    private

    def _template
      TemplateFactory.instance.for( topic ) ||
        raise( TemplateNotFoundError, "topic #{ topic } is not set up")
    end
  end
end
