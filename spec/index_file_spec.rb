require "spec_helper"

RSpec.describe SearchAddress::IndexFile do
  describe ".exist?" do
    it "returns whether existing index file" do
      expect(SearchAddress::IndexFile.exist?).to eq true
    end
  end
end
