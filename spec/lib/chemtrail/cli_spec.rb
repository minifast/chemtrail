require "spec_helper"

describe Chemtrail::Cli do
  let(:taco_json) { JSON.pretty_generate(Tacos.new.to_hash) }
  let(:fake_cloud_formation) { double(:cloud_formation) }

  subject(:cli) { Chemtrail::Cli.new }

  before { cli.cloud_formation = fake_cloud_formation }

  describe "#list" do
    it "lists available templates" do
      got_tacos = false
      Kernel.stub(:puts) { |string| got_tacos ||= (string == "tacos") }
      expect { cli.list }.to change{ got_tacos }.to(true)
    end
  end

  describe "#build" do
    it "builds the specified template" do
      Kernel.should_receive(:puts).with(taco_json)
      cli.build("tacos")
    end

    context "when the template does not exist" do
      it "blows up" do
        expect { cli.build("house of cards") }.to raise_error(Thor::Error)
      end
    end
  end

  describe "#validate" do
    before { Kernel.stub(:puts) }

    it "validates verifies the specified template" do
      fake_cloud_formation.should_receive(:validate_template).with(template_body: taco_json)
      cli.validate("tacos")
    end

    context "when the template does not exist" do
      it "blows up" do
        expect { cli.build("an toenails") }.to raise_error(Thor::Error)
      end
    end

    context "when the template validation blows up" do
      before do
        fake_cloud_formation.stub(:validate_template) do
          raise Aws::CloudFormation::Errors::ValidationError.new("ugh swans")
        end
      end

      it "blows up" do
        expect { cli.build("sustainable hookahs") }.to raise_error(Thor::Error)
      end
    end
  end
end
