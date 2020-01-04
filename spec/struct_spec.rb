require "spec_helper"

RSpec.describe NxtConfig::Struct do
  let(:source_hash) do
    {
      flat_attribute: "hello world",
      http: {
        headers: {
          user_agent: "my cool app",
          api_key: "secret123"
        }
      },
      mail: {
        sender: "john.doe@example.org",
        server: "smtp://example.org"
      },
      array_of_strings: [
        "one",
        "two",
        "three"
      ],
      array_of_hashes: [
        { key: 'value' }
      ]
    }
  end

  subject { described_class.new(source_hash) }

  describe "key attribute accessor methods" do
    context "when the attribute exists" do
      context "and is flat" do
        it "returns the attribute value" do
          expect(subject.flat_attribute).to eq "hello world"
        end
      end

      context "nesting" do
        it "returns nested data as a struct" do
          expect(subject.http).to be_a NxtConfig::Struct
        end

        it "returns the leave values when chained" do
          expect(subject.http.headers.user_agent).to eq "my cool app"
        end
      end

      context "and is an array" do
        it "returns hash items as structs" do
          expect(subject.array_of_hashes).to be_an Array
          expect(subject.array_of_hashes.first).to be_a NxtConfig::Struct
          expect(subject.array_of_hashes.first.key).to eq "value"
        end
      end
    end

    context "when the attribute does not exist" do
      it "raises an error" do
        expect { subject.unknown_attr }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#[]" do
    context "when the key exists" do
      context "when the key is a symbol" do
        it "accesses the data of the struct" do
          expect(subject[:http][:headers][:user_agent]).to eq "my cool app"
        end
      end

      context "when the key is a string" do
        it "accesses the data of the struct" do
          expect(subject["http"]["headers"]["user_agent"]).to eq "my cool app"
        end
      end
    end

    context "when the key does not exist" do
      it "accesses the data of the struct" do
        expect(subject[:nils]).to be_nil
      end
    end
  end
end
