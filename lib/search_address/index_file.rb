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
    def initialize
      @data      = Hash.new { |hash, key| hash[key] = [] }
      @separated = {}

      read_csv_file if @@csv.nil?
    end

    def create
      create_separated_data do |row, row_number|
         postcode, *address = row.values_at(Define::COLUMN_POSTCODE,
                                            Define::COLUMN_PREFECTURES,
                                            Define::COLUMN_CITY,
                                            Define::COLUMN_TOWN)

         address.join
                .to_ngram_index(2) do |index_key|
          @data[index_key] |= [row_number]
         end
      end

      YAML.dump(@data, File.open(Define::INDEX_FILE_PATH, "w"))
    end

    def read
      @data = File.open(Define::INDEX_FILE_PATH, "r") { |file| YAML.load(file) }
      create_separated_data
    end

    private

    def read_csv_file
      if File.exist?(Define::CSV_FILE_PATH)
        file  = File.open(Define::CSV_FILE_PATH, "rb:Shift_JIS:UTF-8", undef: :replace)
        @@csv = CSV.parse(file)
        file.close
      else
        raise SearchAddressError, "住所データファイルが存在しません(search_address/download/KEN_ALL.csv)"
      end
    rescue SearchAddressError => error
      puts "\r\e[2K#{error.message}"
      exit!
    end

    def create_separated_data
      @@csv.each_with_index do |row, row_number|
        postcode, *address = row.values_at(Define::COLUMN_POSTCODE,
                                           Define::COLUMN_PREFECTURES,
                                           Define::COLUMN_CITY,
                                           Define::COLUMN_TOWN)

        yield(row, row_number) if block_given?

        if @separated.has_key?(postcode) && row[Define::COLUMN_OVER_TOWN_FLAG] == "0"
          @separated[postcode] << address[2]
        elsif row[Define::COLUMN_OVER_TOWN_FLAG] == "0"
          @separated[postcode] = [address[2]]
        end
      end
      @separated.select { |postcode, row_numbers| row_numbers.size > 1 }
    end
  end
end

class String
  def to_ngram_index(n)
    each_char.each_cons(n) do |chars|
      yield chars.join
    end
  end
end