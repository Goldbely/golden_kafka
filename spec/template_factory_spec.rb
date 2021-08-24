# frozen_string_literal: true

RSpec.describe GoldenKafka::TemplateFactory do
  subject( :factory ) { described_class.instance }

  describe "for" do
    context "when topic is set up in config file" do
      it "returns the template for it" do
        expect( factory.for "com.example.topic" ).to eq(
          "dataschema" => "v1",
          "source" => "earth",
          "type" => "new",
        )
      end
    end

    context "when topic is NOT set up in config file" do
      it "returns nil" do
        expect( factory.for "non.existent.topic" ).to be_nil
      end
    end
  end
end
