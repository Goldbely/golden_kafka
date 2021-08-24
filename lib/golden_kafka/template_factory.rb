# frozen_string_literal: true
require "singleton"

module GoldenKafka
  class TemplateFactory
    include Singleton

    def for topic
      _templates[ topic.to_s ]
    end

    private

    def _templates
      @_templates ||= _config[ "events" ]
    end

    def _config
      @_config ||= YAML.safe_load ERB.new( File.read( _config_path ) ).result
    end

    def _config_path
      path = defined?( Rails ) ? Rails.root : File
      path.join "config", "golden_kafka.yml"
    end
  end
end
