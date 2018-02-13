require "pp"

require "search_address/version"
require "search_address/define"
require "search_address/manager"
require "search_address/index_file"

module SearchAddress
  class SearchAddressError < StandardError; end

  extend Manager

  class << self
    def run
      index_file = read_csv_file { IndexFile.new }

      if IndexFile.exist?
        read_index_file { index_file.read }
      else
        create_index_file { index_file.create }
      end

      interactive_operation do |key_words|
        index_file.search_from_index(key_words)
      end
    end
  end
end
