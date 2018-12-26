require 'yaml'

module Io
  def self.create_filename(incomplete = true)
    t = Time.now
    t.hour < 10 ? hour = '0' + t.hour.to_s : hour = t.hour
    t.min < 10 ? min = '0' + t.min.to_s : min = t.min
    t.sec < 10 ? sec = '0' + t.sec.to_s : sec = t.sec

    if incomplete == true
      filename = "incomplete_#{t.year}-#{t.month}-#{t.day}_#{hour}h#{min}m#{sec}s"
    else
      filename = "complete_#{t.year}-#{t.month}-#{t.day}_#{hour}h#{min}m#{sec}s"
    end
  end

  def self.mk_dirs
    mk_dir = Proc.new { |dir| Dir.mkdir(dir) unless File.exists? dir }
    mk_dir.call("games")
    mk_dir.call("games/incomplete")
    mk_dir.call("games/complete")
  end

  def self.list_files(dir, ext)
    ext == 'yml' ? split = 17 : split = 15
    list = Dir.glob("games/#{dir}/*.{#{ext},#{ext.upcase}}").map {|e| e[split..-1]}
    list = list.sort.reverse
  end

  def self.save(game, board = nil)
    if game.game_over == ''
      save_data = YAML.dump ({
        :game => {:moves => game.moves,
                  :pgn_list => game.pgn_list,
                  :game_pieces => game.game_pieces,
                  :posn_list => game.posn_list,
                  :pgn => game.pgn,
                  :w_material => game.w_material,
                  :b_material => game.b_material,
                  :ply => game.ply,
                  :to_move => game.to_move,
                  :checks => game.checks,
                  :check_blocks => game.check_blocks,
                  :pinned => game.pinned,
                  :game_over => game.game_over,
                  :checksums => game.checksums,
                  :checksum_dbls => game.checksum_dbls,
                  :threefold => game.threefold},
        :board => {:start_end => board.start_end}
      })
      filename = create_filename(incomplete = true)
      File.open("games/incomplete/#{filename}.yml", 'w'){|f| f.write(save_data)}
    else
      t = Time.now
      if game.moves[-1][3].include?('1-0')
        result = '1-0'
      elsif game.moves[-1][3].include?('0-1')
        result = '0-1'
      else
        result = '1/2-1/2'
      end
      save_data = "[Event \"RubyChess\"]\n" +
                  "[Date \"#{t.year}.#{t.month}.#{t.day}\"]\n" +
                  "[White \"Human\"]\n[Black \"Human\"]\n" +
                  "[Result \"#{result}\"]\n\n#{game.pgn}"
      filename = create_filename(incomplete = false)
      File.open("games/complete/#{filename}.pgn", 'w'){|f| f.write(save_data)}
    end

    filename
  end

  def self.autosave(last_save, game, board = nil)
    last_save = "games/incomplete/#{last_save}.yml"
    File.delete(last_save) if File.exists? last_save
    save(game, board)
  end

  def self.load_file(filename, game, board, error = 'none')
    data = nil
    begin
      if filename[-4..-1] == '.yml' || filename[-4..-1] == '.YML'
        data = YAML::load_file("games/incomplete/#{filename}")
      elsif filename[-4..-1] == '.pgn' || filename[-4..-1] == '.PGN'
        puts filename
        data = File.read("games/complete/#{filename}")
        puts data
        data, error = read_info_and_pgn(data, filename, game, board)
      end
    #rescue StandardError => error
      #error = 'cannot open file (check permissions)'
    end
    return data, error
  end

  def self.read_info_and_pgn(data, filename, game, board)
    error = 'none'
    list = {'[event ' => nil, '[date ' => nil, '[white ' => nil, '[black ' => nil}
    info = nil
    title = ''
    pgn_list = ''

    begin
      if data.include?(']')
        temp = data.strip.split(']')
        info = temp[0..-2].join.strip.split("\n")
        pgn_list = temp[-1].strip.split("\n").join(' ')
        list.each_key do |key|
          info.each do |e|
            if e.downcase.include?(key)
              list[key] = e.split("\"")[1].strip
            end
          end
        end
      else
        pgn_list = data.strip.split("\n").join
      end

      pgn_list = pgn_list.split('}').map! {|e| e.split(' {')[0]}
      pgn_list = pgn_list.join.strip.split(" ").delete_if {|e| e.include?('.')}
      pgn_list[-1] = '1/2-1/2' if pgn_list[-1] == '½-½'
      error = "bad / missing result format" unless pgn_list[-1] =~ /^1-0$|^0-1$|^1\/2-1\/2$/
      pgn_list[0..-2].each do |e|
        error = "bad move format found" if e.length < 2 || e.length > 7
        e.each_char do |c|
          legal_char = c =~ /^[a-hxBKNORQ1-8=+#-]+/
          error = "illegal character found in move" if legal_char == nil
        end
      end

    rescue StandardError => error
      error = 'cannot parse file contents'
    end

    unless error == 'none'
      puts "ERROR! #{error}" # print error to load_save menu && do not load game
      puts "---------------------------------------------------------------------------------------------------------"
    else # parse data components
      print_parsed(filename, list, info, pgn_list)
      # to do:
        # test moves for legality... (implicitly will do exhaustive move format check, as
          # final comparison of pgn generated with pgn input will be true or false)
    end

    #return data, error
  end

  def self.print_parsed(filename, list, info, pgn_list)
    if info == nil || list.all? {|k, v| v == nil}
      title = "File: #{filename} (no details)"
    else
      title = "#{list['[white ']} v #{list['[black ']} (#{list['[event ']}, #{list['[date ']})"
    end
    # to do: shorten overly long title(s)...
    puts "Title: #{title}"
    puts "Moves: #{pgn_list}"
    puts "---------------------------------------------------------------------------------------------------------"
  end

end
