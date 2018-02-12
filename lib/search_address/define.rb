module SearchAddress
  module Define
    CSV_FILE_PATH   = File.expand_path("../../../download/KEN_ALL.CSV", __FILE__).freeze
    INDEX_FILE_PATH = File.expand_path("../../../output/search_index.yaml", __FILE__).freeze

    COLUMN_POSTCODE       = 2
    COLUMN_PREFECTURES    = 6
    COLUMN_CITY           = 7
    COLUMN_TOWN           = 8
    COLUMN_OVER_TOWN_FLAG = 12
  end
  Define.freeze
end