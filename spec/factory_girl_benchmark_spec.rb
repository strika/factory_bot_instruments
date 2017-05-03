require "spec_helper"

module IOHelper
  def self.capture(&block)
    begin
      $stdout = StringIO.new
      yield
      result = $stdout.string
    ensure
      $stdout = STDOUT
    end

    result
  end
end

RSpec.describe FactoryGirlBenchmark do
  it "has a version number" do
    expect(FactoryGirlBenchmark::VERSION).not_to be_nil
  end

  describe ".run" do
    it "keeps the db clean" do
      expect { FactoryGirlBenchmark.run }.to_not change { User.count }
    end

    it "prints the benchmark on STDOUT" do
      output = IOHelper.capture { FactoryGirlBenchmark.run }

      output.split("\n") do |line|
        expect(line).to match(/\d+.\d+s\: FactoryGirl\..+\(\:.+\)/)
      end
    end
  end

  describe ".benchmark" do
    it "keeps the db clean" do
      expect { FactoryGirlBenchmark.benchmark(:user) }.to_not change { User.count }
    end

    it "returns the duration in seconds" do
      expect(FactoryGirlBenchmark.benchmark(:user)).to be_instance_of(FactoryGirlBenchmark::Benchmark)
    end

    it "measures 'FactoryGirl.create' by default" do
      expect(FactoryGirl).to receive(:create)

      FactoryGirlBenchmark.benchmark(:user)
    end

    it "can measure 'FactoryGirl.build'" do
      expect(FactoryGirl).to receive(:build)

      FactoryGirlBenchmark.benchmark(:user, :method => :build)
    end

    it "can measure 'FactoryGirl.build_stubbed'" do
      expect(FactoryGirl).to receive(:build_stubbed)

      FactoryGirlBenchmark.benchmark(:user, :method => :build_stubbed)
    end
  end
end
