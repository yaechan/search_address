module Manager
  def read_csv_file(&block)
    setup_thread("住所データファイルを読み込み中です", &block)
  end

  def read_index_file(&block)
    setup_thread("インデックスファイルを読み込み中です", &block)
  end

  def create_index_file(&block)
    setup_thread("インデックスファイルを作成中です", &block)
  end

  def interactive_operation
    while true
      print "\r\e[2K入力:"
      input = gets

      key_words = input && get_key_words(input)

      case key_words
      when nil, "quit".split(//)
        exit_search
      when []
        next
      end

      puts "出力:"

      yield key_words

    end

  rescue Interrupt
    exit_search
  end

  private

  def get_key_words(input)
    input.chomp
         .encode("UTF-8", undef: :replace)
         .gsub(/(\s|[[:blank:]])/, "")
         .split(//)
  end

  def setup_thread(output)
    thread = start_thread(output)

    data   = yield

    kill_thread(thread)

    data
  end

  def start_thread(output, sleep_time=1)
    Thread.start do
      Thread.pass

      1.step do |step_number|
        print "\r\e[2K#{output + ("." * (step_number % 4))}"
        sleep sleep_time

        $stdout.flush
      end
    end
  end

  def kill_thread(thread)
    Thread.kill(thread)
  end

  def exit_search
    puts "\n終了します"
    exit!
  end
end