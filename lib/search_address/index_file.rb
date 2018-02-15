require "csv"
require "yaml"
require "search_address/index_file/search"

module SearchAddress
  class IndexFile
    include Search

    class << self
      def exist?
        File.exist?(Define::INDEX_FILE_PATH)
      end
    end

    attr_accessor :data, :separated

    # @data      インデックスデータを格納
    # @separated 要連結住所データを格納
    def initialize
      @data      = Hash.new { |hash, key| hash[key] = [] }
      @separated = Hash.new { |hash, key| hash[key] = [] }

      read_csv_file if @@csv.nil?
    end

    def create
      create_separated_data do |row, row_number|
        postcode, *address = get_postcode_and_address(row)

        address.join
               .to_ngram_index do |index_key|
          @data[index_key] |= [row_number]
        end
      end

      create_index_file
    end

    def read
      @data = read_index_file
      create_separated_data
    end

    private

    def create_index_file
      YAML.dump(@data, File.open(Define::INDEX_FILE_PATH, "w"))
    end

    def read_index_file
      File.open(Define::INDEX_FILE_PATH, "r") { |file| YAML.load(file) }
    end

    def read_csv_file
        if File.exist?(Define::CSV_FILE_PATH)
        File.open(Define::CSV_FILE_PATH, "rb:Shift_JIS:UTF-8", undef: :replace) do |file|
          @@csv = CSV.parse(file)
        end
      else
        raise SearchAddressError, "住所データファイルが存在しません(search_address/download/KEN_ALL.csv)"
      end

    rescue SearchAddressError => error
      puts "\r\e[2K#{error.message}"
      exit!
    end

    def create_separated_data
      @@csv.each_with_index do |row, row_number|
        yield(row, row_number) if block_given?

        postcode, *address = get_postcode_and_address(row)

        # 住所レコードの12番目要素が"1"の要素は1つの郵便番号に対して複数のレコードが存在する為、要結合レコードの判定をできない。
        # よって12番目の要素が"0"のレコードに絞って要結合レコードを探す
        if row[Define::COLUMN_OVER_TOWN_FLAG] == Define::NOT_APPLICABLE
          @separated[postcode] << address[2]
        end
      end

      @separated.select { |postcode, row_numbers| row_numbers.size > 1 }
    end
  end
end

class String
  def to_ngram_index(n=2)
    each_char.each_cons(n) do |chars|
      yield chars.join
    end
  end
end