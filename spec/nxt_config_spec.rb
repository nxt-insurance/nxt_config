require 'date'

RSpec.describe NxtConfig do
  it "has a version number" do
    expect(NxtConfig::VERSION).not_to be nil
  end

  describe "::load" do
    subject do
      NxtConfig.load(source_file)
    end

    context "with yaml file" do
      let(:source_file) { "spec/fixtures/example.yml" }

      it "instantiates a config struct" do
        expect(subject).to be_a NxtConfig::Struct
        expect(subject.http.headers.user_agent).to eq "my cool app"
      end
    end

    context "with yaml file that contains erb content" do
      let(:source_file) { "spec/fixtures/example_with_erb_content.yml" }

      it "instantiates a config struct" do
        expect(subject).to be_a NxtConfig::Struct
        expect(subject.attr).to eq File.read(".ruby-version").strip # erb content of attr value
      end
    end
  end
end
