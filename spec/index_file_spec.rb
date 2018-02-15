require "spec_helper"

RSpec.describe SearchAddress::IndexFile do
  describe ".exist?" do
    it "returns whether existing index file" do
      index_file_mock = class_double(SearchAddress::IndexFile)
      allow(index_file_mock).to receive(:exist?).and_return(true)

      expect(index_file_mock).to exist
    end
  end

  let(:index_file) do
    allow(SearchAddress::IndexFile.new).to receive(:read_csv_file).and_return(true)
    SearchAddress::IndexFile.new
  end

  describe "#new" do
    subject { index_file }

    it { is_expected.to respond_to(:data, :separated, :create, :read) }
  end

  describe "#data" do
    subject { index_file.data }

    it { is_expected.to be_empty }

    it "is Hash" do
      expect(subject.class).to eq Hash
    end
  end

  describe "#separated" do
    subject { index_file.separated }

    it { is_expected.to be_empty }

    it "is Hash" do
      expect(subject.class).to eq Hash
    end
  end

  describe "#create" do
    let(:row) do
      [[nil, nil, "10000001", nil, nil, nil, "都", "区", "町"],
       [nil, nil, "99999999", nil, nil, nil, "県", "市", "区"]]
    end
    let(:row_number) { [1, 2] }
    let(:data) do
      { "区町" => [1],
        "市区" => [2],
        "県市" => [2],
        "都区" => [1] }
    end

    it "add to @data" do
      create_separated_data_mock = double("create_separated_data")
      allow(index_file).to receive(:create_separated_data).and_return(create_separated_data_mock)
                                                          .and_yield(row[0], row_number[0])
                                                          .and_yield(row[1], row_number[1])
      allow(index_file).to receive(:create_index_file).and_return(true)

      index_file.create
      expect(index_file.data).to eq data
    end
  end

  describe "#read" do
    let(:data) do
      { "区町" => [1],
        "市区" => [2],
        "県市" => [2],
        "都区" => [1] }
    end

    it "add to @data" do
      allow(index_file).to receive(:read_index_file).and_return(data)
      allow(index_file).to receive(:create_separated_data).and_return(true)

      index_file.read
      expect(index_file.data).to eq data
    end
  end
end


RSpec.describe String do
  describe "#to_ngram_index" do
    let(:key_word) { "都道府県" }

    it "" do
      expect{ |b| key_word.to_ngram_index(2, &b) }.to yield_successive_args("都道", "道府", "府県")
    end
  end
end