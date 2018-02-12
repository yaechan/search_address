module SearchAddress
  module Define
    CSV_FILE_PATH   = File.expand_path("../../../download/KEN_ALL.CSV", __FILE__).freeze
    INDEX_FILE_PATH = File.expand_path("../../../output/search_index.yaml", __FILE__).freeze
  end
end