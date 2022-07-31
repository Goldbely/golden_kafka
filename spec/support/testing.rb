# frozen_string_literal: true

module GoldenKafka
  module Testing
    class DummyMessage
      def initialize attrs
        @attrs = attrs
      end

      def to_json _opts = nil
        @attrs.to_json
      end
    end
  end
end
