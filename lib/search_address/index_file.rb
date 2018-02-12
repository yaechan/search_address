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
         postcode, *address = row.values_at(2, 6, 7, 8)

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
      file  = File.open(Define::CSV_FILE_PATH, "rb:Shift_JIS:UTF-8", undef: :replace)
      @@csv = CSV.parse(file)
      file.close
    end

    def create_separated_data
      @@csv.each_with_index do |row, row_number|
        postcode, *address = row.values_at(2, 6, 7, 8)

        yield(row, row_number) if block_given?

        if @separated.has_key?(postcode) && row[12] == "0"
          @separated[postcode] << address[2]
        elsif row[12] == "0"
          @separated[postcode] = [address[2]]
        end
      end
      @separated.select { |postcode, row_numbers| row_numbers.length > 1 }
    end
  end
end

class String
  def to_ngram_index(n)
    each_char.each_cons(2) do |chars|
      yield chars.join
    end
  end
end