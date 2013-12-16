require "spec_helper"

describe Chemtrail::Cli do
  subject(:cli) { Chemtrail::Cli.new }

  describe "#list" do
    it "lists available templates" do
      got_tacos = false
      Kernel.stub(:puts) { |string| got_tacos ||= (string == "tacos") }
      expect { cli.list }.to change{ got_tacos }.to(true)
    end
  end

  describe "#build" do
    it "builds the specified template" do
      Kernel.should_receive(:puts).with(JSON.pretty_generate(Tacos.new.to_hash))
      cli.build("tacos")
    end

    context "when the template does not exist" do
      it "blows up" do
        expect { cli.build("house of cards") }.to raise_error(Thor::Error)
      end
    end
  end
end
