require "spec_helper"

RSpec.describe Search do
  let(:index_file) { SearchAddress::IndexFile.new }

  describe "#search_from_index" do
    let(:key_words) { ["町", "街"] }
    let(:data) do
      { "区町" => [1],
        "市区" => [2],
        "県市" => [2],
        "都区" => [1] }
    end

    it "shoud not raise Exception" do
      index_file.instance_variable_set(:@data, data)
      expect(index_file).to receive(:search_from_csv).and_return(true).once
      expect{ index_file.search_from_index(key_words) }.to_not raise_error
    end
  end

  describe "#search_from_csv" do
  end
end