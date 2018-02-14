require "spec_helper"

RSpec.describe Manager do
  let(:inner_value) { "value" }
  let(:stdout) { $stdout.string }

  before do
    $stdin  = StringIO.new
    $stdout = StringIO.new
  end

  after do
    $stdin  = STDIN
    $stdout = STDOUT
  end

  describe "#read_csv_file" do
    let(:value) do
      SearchAddress.read_csv_file { inner_value }
    end

    it "returns value that block returned" do
      expect(value).to eq inner_value
    end

    it "outputs to stdout in block" do
      SearchAddress.read_csv_file do
        sleep 1
        expect(stdout).to start_with "\r\e[2K住所データファイルを読み込み中です"
      end
    end
  end

  describe "#read_index_file" do
    let(:value) do
      SearchAddress.read_index_file { inner_value }
    end

    it "returns value that block returned" do
      expect(value).to eq inner_value
    end

    it "outputs to stdout in block" do
      SearchAddress.read_index_file do
        sleep 1
        expect(stdout).to start_with "\r\e[2Kインデックスファイルを読み込み中です"
      end
    end
  end

  describe "#create_index_file" do
    let(:value) do
      SearchAddress.create_index_file { inner_value }
    end

    it "returns value that block returned" do
      expect(value).to eq inner_value
    end

    it "outputs to stdout in block" do
      SearchAddress.create_index_file do
        sleep 1
        expect(stdout).to start_with "\r\e[2Kインデックスファイルを作成中です"
      end
    end
  end

  describe "#interactive_operation" do
    let(:key_word) { "渋谷\n" }
    let(:yield_param) do
      key_word.chomp
              .encode("UTF-8", undef: :replace)
              .gsub(/(\s| )/, "")
              .split(//)
    end

    it "" do
      search_address_mock = class_double(SearchAddress)
      allow(SearchAddress).to receive(:gets).and_return(key_word)

      expect(SearchAddress.interactive_operation { |key| break key }).to eq yield_param
    end
  end
end
