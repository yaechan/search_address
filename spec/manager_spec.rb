require "spec_helper"

RSpec.describe Manager do
  let(:inner_value) { "value" }
  let(:stdout) { $stdout.string.encode("UTF-8", undef: :replace) }

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
    let(:key_word)                { "渋谷\n" }
    let(:key_word_include_space)  { "渋 谷　\n" }
    let(:yield_param)             { ["渋", "谷"] }

    context "when key_word don't includ space" do
      it "should retrun array from which impurities has been taken" do
        expect(SearchAddress).to receive(:gets).and_return(key_word).once

        expect(SearchAddress.interactive_operation { |key| break key }).to eq yield_param
      end
    end

    context "when key_word includs space" do
      it "should retrun array from which impurities has been taken" do
        expect(SearchAddress).to receive(:gets).and_return(key_word_include_space).once

        expect(SearchAddress.interactive_operation { |key| break key }).to eq yield_param
      end
    end

    context "when key_word is '\\n'" do
      it "shoud not raise Exception" do
        expect(SearchAddress).to receive(:gets).and_return("\n", key_word).twice

        expect{ SearchAddress.interactive_operation { |key| break key } }.to_not raise_error
      end
    end

    context "when key_word is 'quit\\n', 'nil'" do
      it "shoud not raise Exception" do
        expect(SearchAddress).to receive(:gets).and_return("quit\n", nil).twice
        expect(SearchAddress).to receive(:exit_search).and_return(true).twice

        expect{ SearchAddress.interactive_operation { |key| break key if key.nil? } }.to_not raise_error
      end
    end

    context "when Interrupt" do
      it "shuld raise Exception" do
        expect(SearchAddress).to receive(:gets).and_return(->{ raise Interrupt })
        allow(SearchAddress).to  receive(:exit_search).and_return(true)

        expect { SearchAddress.interactive_operation { |key| break key } }.to raise_error
      end
    end
  end
end
