module Search
  @@csv = nil

  def search_from_index(key_word)
    init_key_word = key_word.shift

    @data.each_with_object([]) do |(index_key, row_numbers), treated_row_numbers|
      if index_key.match(/#{init_key_word}/)
        search_from_csv(row_numbers, key_word, treated_row_numbers)
      end
    end
  end

  def search_from_csv(row_numbers, key_word, treated_row_numbers)
    row_numbers.each do |row_number|
      next if treated_row_numbers.include?(row_number)

      treated_row_numbers << row_number
      postcode, *address = @@csv[row_number].values_at(SearchAddress::Define::COLUMN_POSTCODE,
                                                       SearchAddress::Define::COLUMN_PREFECTURES,
                                                       SearchAddress::Define::COLUMN_CITY,
                                                       SearchAddress::Define::COLUMN_TOWN)
      address[2] = @separated[postcode].join if @separated.has_key?(postcode)
      pattern = /^#{key_word.reduce("") { |memo, char| memo << "(?=.*#{char})" }}/

      if address.join.match(pattern)
        puts address.unshift(postcode)
                    .map { |column| column.gsub(/^|$/, "\"") }
                    .join(",")
      end
    end
  end
end