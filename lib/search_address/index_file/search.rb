module Search
  # 住所レコードデータの配列を格納
  @@csv = nil

  def search_from_index(key_words)
    init_key_word = key_words.shift

    @data.each_with_object([]) do |(index_key, row_numbers), treated_row_numbers|
      if index_key.match(/#{init_key_word}/)
        row_numbers -= treated_row_numbers
        treated_row_numbers.concat(row_numbers)

        search_from_csv(row_numbers, key_words)
      end
    end
  end

  private

  def search_from_csv(row_numbers, key_words)
    row_numbers.each do |row_number|
      postcode, *address = get_postcode_and_address(@@csv[row_number])
      address[2]         = @separated[postcode].join if @separated.has_key?(postcode)
      pattern            = /^#{key_words.reduce("") { |memo, char| memo << "(?=.*#{char})" }}/

      if address.join.match(pattern)
        puts address.unshift(postcode)
                    .map { |column| column.gsub(/^|$/, "\"") }
                    .join(",")
      end
    end
  end

  def get_postcode_and_address(row)
    row.values_at(SearchAddress::Define::COLUMN_POSTCODE,
                  SearchAddress::Define::COLUMN_PREFECTURE,
                  SearchAddress::Define::COLUMN_CITY,
                  SearchAddress::Define::COLUMN_TOWN)
  end
end