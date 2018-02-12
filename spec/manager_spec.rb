require "spec_helper"

RSpec.describe Manager do
  let(:inner_value) { "value" }

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
      stdout  = nil
      SearchAddress.read_csv_file do
        sleep 1
        stdout = $stdout.string
      end
      expect(stdout).to include "\r\e[2K住所データファイルを読み込み中です"
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
      stdout  = nil
      SearchAddress.read_index_file do
        sleep 1
        stdout = $stdout.string
      end
      expect(stdout).to include "\r\e[2Kインデックスファイルを読み込み中です"
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
      stdout  = nil
      SearchAddress.create_index_file do
        sleep 1
        stdout = $stdout.string
      end
      expect(stdout).to include "\r\e[2Kインデックスファイルを作成中です"
    end
  end

  describe "#interactive_operation" do
    it "yield with Array" do
      #expect { |b| SearchAddress.interactive_operation(&b) }.to yield_with_args(Array)
    end
  end
end
