require "spec_helper"

RSpec.describe Search do
  let(:index_file) { SearchAddress::IndexFile.new }

  describe "#search_from_index" do


    it "shoud not raise Exception" do
      #index_file_mock = instance_double(SearchAddress::IndexFile)
      #allow(index_file_mock).to receive(:search_from_index)
      #search_from_csv_mock = double(:search_from_csv)
      #allow(index_file).to receive(:search_from_csv).and_return(search_from_csv_mock)
    end
  end

  describe "#search_from_csv" do
  end
end