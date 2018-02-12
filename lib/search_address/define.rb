module SearchAddress
  module Define
    CSV_FILE_PATH   = File.expand_path("../../../download/KEN_ALL.CSV", __FILE__).freeze
    INDEX_FILE_PATH = File.expand_path("../../../output/search_index.yaml", __FILE__).freeze

    COLUMN_POSTCODE       = 2.freeze
    COLUMN_PREFECTURES    = 6.freeze
    COLUMN_CITY           = 7.freeze
    COLUMN_TOWN           = 8.freeze
    COLUMN_OVER_TOWN_FLAG = 12.freeze
  end

  Define.freeze
end