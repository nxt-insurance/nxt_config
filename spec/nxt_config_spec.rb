require 'date'

RSpec.describe NxtConfig do
  it "has a version number" do
    expect(NxtConfig::VERSION).not_to be nil
  end

  describe "::load_and_constantize" do
    subject do
      NxtConfig.load_and_constantize(
        source: source_file,
        constant_name: constant_name,
        namespace: namespace
      )
    end

    context "with yaml file without namespace specified" do
      let(:source_file) { "spec/fixtures/example.yml" }
      let(:constant_name) { "Config" }
      let(:namespace) { nil } # no namespace

      after { Object.send(:remove_const, constant_name) }

      it "defines the constant and populates the source data to it" do
        subject
        expect(Config).to be_a NxtConfig::Struct
        expect(Config.http.headers.user_agent).to eq "my cool app"
      end
    end

    context "with yaml file that contains erb content" do
      let(:source_file) { "spec/fixtures/example_with_erb_content.yml" }
      let(:constant_name) { "Config" }
      let(:namespace) { nil } # no namespace

      after { Object.send(:remove_const, constant_name) }

      it "defines the constant and populates the source data after evaluating the erb content to it" do
        subject
        expect(Config).to be_a NxtConfig::Struct
        expect(Config.attr).to eq File.read(".ruby-version").strip # erb content of attr value
      end
    end

    context "with yaml file with namespace specified" do
      before do
        module MyApp; end
      end

      let(:source_file) { "spec/fixtures/example.yml" }
      let(:constant_name) { "Config" }
      let(:namespace) { MyApp }

      after { namespace.send(:remove_const, constant_name) }

      it "defines the constant and populates the source data to it" do
        subject
        expect(MyApp::Config).to be_a NxtConfig::Struct
        expect(MyApp::Config.http.headers.user_agent).to eq "my cool app"
      end
    end

    context "when constant name is already in use" do
      before do
        module Config; end
      end

      let(:source_file) { "spec/fixtures/example.yml" }
      let(:constant_name) { "Config" }
      let(:namespace) { nil } # no namespace

      it "raises an error" do
        expect { subject }.to raise_error(
          NxtConfig::ConstantNameAlreadyTaken,
          "Cannot define constant Config on Object because it already exists."
        )
      end
    end
  end
end
