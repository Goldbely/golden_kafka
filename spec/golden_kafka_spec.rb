# frozen_string_literal: true

# TODO:
# - avoid some repetition with methods delegated to Delivery Boy
# - factories/fixtures for events? (valid, invalid, nonexistent topic)
RSpec.describe GoldenKafka do
  describe "#configure_delivery_boy" do
    it "allows configuring DeliveryBoy" do
      DeliveryBoy.config.log_level = :warn

      expect do
        described_class.configure_delivery_boy do |config|
          config.log_level = :error
        end
      end.to change( DeliveryBoy.config, :log_level ).from( :warn ).to :error
    end
  end

  describe "#deliver" do
    context "when event is valid" do
      let( :event ) { GoldenKafka::Event.new "com.example.topic", source: "a_source" }

      it "queues it" do
        described_class.deliver event, partition_key: "a_key"

        messages = DeliveryBoy.testing.messages_for "com.example.topic"

        expect( messages.first ).to have_attributes(
          partition_key: "a_key",
          value: event.to_json,
        )
      end
    end

    context "when event is not valid" do
      let( :event ) { GoldenKafka::Event.new "com.example.topic", source: nil }

      it "does not queue it" do
        described_class.deliver event rescue GoldenKafka::Error

        messages = DeliveryBoy.testing.messages_for "com.example.topic"
        expect( messages.count ).to eq 0
      end

      it "raises an expection" do
        expect do
          described_class.deliver event
        end.to raise_error(
          GoldenKafka::FormatException,
          "event payload must comply with GB guidelines",
        )
      end
    end

    context "when event does not exist" do
      let( :event ) { GoldenKafka::Event.new "a_topic" }

      it "raises an expection" do
        expect do
          described_class.deliver event
        end.to raise_error(
          GoldenKafka::TemplateNotFoundError,
          "topic a_topic is not set up",
        )
      end
    end
  end

  describe "#deliver_async" do
    context "when event is valid" do
      let( :event ) { GoldenKafka::Event.new "com.example.topic", source: "a_source" }

      it "queues it" do
        described_class.deliver_async event, partition_key: "a_key"

        messages = DeliveryBoy.testing.messages_for "com.example.topic"

        expect( messages.first ).to have_attributes(
          partition_key: "a_key",
          value: event.to_json,
        )
      end
    end

    context "when event is not valid" do
      let( :event ) { GoldenKafka::Event.new "com.example.topic", source: nil }

      it "does not queue it" do
        described_class.deliver_async event rescue GoldenKafka::Error

        messages = DeliveryBoy.testing.messages_for "com.example.topic"
        expect( messages.count ).to eq 0
      end

      it "raises an expection" do
        expect do
          described_class.deliver_async event
        end.to raise_error(
          GoldenKafka::FormatException,
          "event payload must comply with GB guidelines",
        )
      end
    end

    context "when event does not exist" do
      let( :event ) { GoldenKafka::Event.new "a_topic" }

      it "raises an expection" do
        expect do
          described_class.deliver_async event
        end.to raise_error(
          GoldenKafka::TemplateNotFoundError,
          "topic a_topic is not set up",
        )
      end
    end
  end

  describe "#produce and #deliver_messages" do
    context "when event is valid" do
      let( :event ) { GoldenKafka::Event.new "com.example.topic", source: "a_source" }

      it "queues it" do
        described_class.produce event, partition_key: "a_key"
        described_class.deliver_messages

        messages = DeliveryBoy.testing.messages_for "com.example.topic"

        expect( messages.first ).to have_attributes(
          partition_key: "a_key",
          value: event.to_json,
        )
      end
    end

    context "when event is not valid" do
      let( :event ) { GoldenKafka::Event.new "com.example.topic", source: nil }

      it "does not queue it" do
        described_class.produce event rescue GoldenKafka::Error
        described_class.deliver_messages

        messages = DeliveryBoy.testing.messages_for "com.example.topic"
        expect( messages.count ).to eq 0
      end

      it "raises an expection" do
        expect do
          described_class.produce event
        end.to raise_error(
          GoldenKafka::FormatException,
          "event payload must comply with GB guidelines",
        )
      end
    end

    context "when event does not exist" do
      let( :event ) { GoldenKafka::Event.new "a_topic" }

      it "raises an expection" do
        expect do
          described_class.produce event
        end.to raise_error(
          GoldenKafka::TemplateNotFoundError,
          "topic a_topic is not set up",
        )
      end
    end
  end
end
