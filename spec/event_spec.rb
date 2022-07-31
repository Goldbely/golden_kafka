# frozen_string_literal: true

RSpec.describe GoldenKafka::Event do
  subject( :event ) { described_class.new "com.example.topic" }

  describe "initialization" do
    it "assignes a random id" do
      expect( event.id ).to_not be_nil
    end

    it "takes default values from the config file" do
      expect( event ).to have_attributes(
        dataschema: "v1",
        source: "earth",
        type: "new",
      )
    end
  end

  describe "validations" do
    before { is_expected.to be_valid }

    it "validates presence of id" do
      event.id = nil

      is_expected.to_not be_valid
    end

    it "validates presence of source" do
      event.source = nil

      is_expected.to_not be_valid
    end

    it "validates presence of type" do
      event.type = nil

      is_expected.to_not be_valid
    end

    it "validates that the topic is set up in the config file" do
      expect do
        described_class.new "non.existent.topic"
      end.to raise_error(
        GoldenKafka::TemplateNotFoundError,
        "topic non.existent.topic is not set up",
      )
    end
  end

  describe "#as_json" do
    it "returns a serializable hash" do
      expect( event.as_json.keys ).to eq([
        :id, :data, :dataschema, :source, :subject, :time, :type,
      ])
    end
  end

  describe "#to_json" do
    it "returns a json representation of the event" do
      expect( event.to_json ).to eq JSON.dump( event.as_json )
    end

    context "when a serializer is provided" do
      it "uses the serializer to serialize the data" do
        serializer =
          Class.new do
            def initialize _attrs; end

            def to_json _opts = nil
              JSON.dump foo: 'bar'
            end
          end

        expect( event.to_json( serializer )).to eq JSON.dump( foo: 'bar' )
      end
    end
  end
end
