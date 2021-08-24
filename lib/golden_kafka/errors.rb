# frozen_string_literal: true

module GoldenKafka
  class Error < StandardError; end
  class FormatException < Error; end
  class TemplateNotFoundError < Error; end
end
