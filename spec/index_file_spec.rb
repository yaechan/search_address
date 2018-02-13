require "spec_helper"

RSpec.describe SearchAddress::IndexFile do
  before(:all) do
    index_file_path = SearchAddress::Define::INDEX_FILE_PATH
    File.delete(index_file_path) if File.exist?(index_file_path)
  end

  describe ".exist?" do
    it "returns whether existing index file" do
      expect(SearchAddress::IndexFile).not_to exist
    end
  end

  let(:index_file) { SearchAddress::IndexFile.new }

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
    before do
      index_file.create
    end

    it "add to @data" do
      expect(index_file.data.size).to be > 0
    end

    it "add to @separated" do
      expect(index_file.separated.size).to be > 0
    end

    it "create index file" do
      expect(SearchAddress::IndexFile).to exist
    end
  end

  describe "#read" do
    before(:context) do
      index_file.read
    end

    it "add to @data" do
      expect(index_file.data.size).to be > 0
    end

    it "add to @separated" do
      expect(index_file.separated.size).to be > 0
    end
  end
end
