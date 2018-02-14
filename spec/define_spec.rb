require "spec_helper"

RSpec.describe SearchAddress::Define do
  let(:define) { SearchAddress::Define }

  describe "::CSV_FILE_PATH" do
    subject { define::CSV_FILE_PATH }

    it "is frozen" do
      expect(subject.frozen?).to be_truthy
    end

    it { is_expected.to end_with "/search_address/download/KEN_ALL.csv" }
  end

  describe "::INDEX_FILE_PATH" do
    subject { define::INDEX_FILE_PATH }

    it "is frozen" do
      expect(subject.frozen?).to be_truthy
    end

    it { is_expected.to end_with "/search_address/output/search_index.yaml" }
  end

  describe "::COLUMN_POSTCODE" do
    subject { define::COLUMN_POSTCODE }

    it "is frozen" do
      expect(subject.frozen?).to be_truthy
    end

    it { is_expected.to eq 2 }
  end

  describe "::COLUMN_PREFECTURE" do
    subject { define::COLUMN_PREFECTURE }

    it "is frozen" do
      expect(subject.frozen?).to be_truthy
    end

    it { is_expected.to eq 6 }
  end

  describe "::COLUMN_CITY" do
    subject { define::COLUMN_CITY }

    it "is frozen" do
      expect(subject.frozen?).to be_truthy
    end

    it { is_expected.to eq 7 }
  end

  describe "::COLUMN_TOWN" do
    subject { define::COLUMN_TOWN }

    it "is frozen" do
      expect(subject.frozen?).to be_truthy
    end

    it { is_expected.to eq 8 }
  end

  describe "::COLUMN_OVER_TOWN_FLAG" do
    subject { define::COLUMN_OVER_TOWN_FLAG }

    it "is frozen" do
      expect(subject.frozen?).to be_truthy
    end

    it { is_expected.to eq 12 }
  end

  describe "::NOT_APPLICABLE" do
    subject { define::NOT_APPLICABLE }

    it "is frozen" do
      expect(subject.frozen?).to be_truthy
    end

    it { is_expected.to eq "0" }
  end
end