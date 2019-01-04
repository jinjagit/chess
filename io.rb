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

  def self.create_yaml(game, board)
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
  end

  def self.save(game, board = nil)
    if game.game_over == ''
      save_data = create_yaml(game, board)
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
        data = File.read("games/complete/#{filename}")
        data, error = read_info_and_pgn(data, filename, game, board)
      end
    rescue StandardError => error
      error = 'cannot open file (check permissions)'
    end
    return data, error
  end

  def self.read_info_and_pgn(data, filename, game, board)
    error = 'none'
    list = {'[event ' => nil, '[date ' => nil, '[white ' => nil, '[black ' => nil}
    info = nil
    title = ''
    pgn_list = ''

    #begin
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

    #rescue StandardError => error
      #error = 'cannot parse file contents'
    #end

    if error == 'none'
      data, error = process_pgn(filename, list, info, pgn_list, game, board)
    else
      puts "ERROR! (before process_pgn) #{error}" # print error to load_save menu && do not load game
      puts "---------------------------------------------------------------------------------------------------------"
    end

    #return data, error # return when developed
  end

  def self.process_pgn(filename, list, info, pgn_list, game, board)
    def self.reset_game(game, board, posn, game_pieces)
      posn = Utilities.start_posn
      game_pieces.each do |e|
        e.reset
        posn.each_with_index do |p, index|
          if p == e.name
            e.square = index
            e.icon.z = 5
          end
        end
      end
      game.reinitialize(game_pieces)
      posn
    end

    correct = [["wp3", 51, 35, ""], ["bp4", 12, 28, ""], ["wp3", 35, 28, "x"], ["bp5", 13, 21, ""], ["wp3", 28, 21, "x"], ["bn1", 6, 23, ""], ["wp3", 21, 14, "x"], ["bn1", 23, 13, ""], ["wq2", 14, 7, "x=Q"], ["bn1", 13, 19, ""], ["wq2", 7, 15, "x"], ["bn1", 19, 13, ""], ["wp7", 55, 39, ""], ["bn1", 13, 19, ""], ["wp7", 39, 31, ""], ["bn1", 19, 13, ""], ["wp7", 31, 23, ""], ["bn1", 13, 19, ""], ["wq2", 15, 6, ""], ["bn1", 19, 13, ""], ["wp7", 23, 15, ""], ["bn1", 13, 19, ""], ["wq3", 15, 7, "=Q"], ["bn1", 19, 13, ""], ["wn0", 57, 42, ""], ["bp3", 11, 19, ""], ["wb0", 58, 37, ""], ["bb0", 2, 11, ""], ["wp6", 54, 46, ""], ["bp1", 9, 17, ""], ["wb1", 61, 54, ""], ["bn0", 1, 18, ""], ["wn1", 62, 45, ""], ["bq0", 3, 12, ""], ["wk0", 60, 62, "O-O"], ["bk0", 4, 2, "O-O-O"], ["wp0", 48, 40, ""], ["bn0", 18, 28, ""], ["wn1", 45, 28, "x"], ["bn1", 13, 28, "x"], ["wb0", 37, 28, "x"], ["bq0", 12, 28, "x"], ["wq3", 7, 28, "x"], ["bp3", 19, 28, "x"], ["wp1", 49, 33, ""], ["bk0", 2, 1, ""], ["wp1", 33, 25, ""], ["bp0", 8, 24, ""], ["wp1", 25, 16, "xep"], ["bb1", 5, 19, ""], ["wp1", 16, 8, "+"], ["bk0", 1, 8, "x"], ["wq2", 6, 3, "x"], ["bb0", 11, 18, ""], ["wb1", 54, 18, "x"], ["bb1", 19, 26, ""], ["wq2", 3, 0, "#1-0"]]

    error = 'none'
    pgn_move = pgn_list[0]
    start_sq = -1
    end_sq = -1
    color = ''
    moves = nil
    move_found = false
    posn_store = []
    game_pieces = []
    posn = []
    new_moves = []
    game_pieces = board.game_pieces
    posn = reset_game(game, board, posn, game_pieces)
    i = 0

    while error == 'none' do
      i % 2 == 0 ? color = 'w' : color = 'b'
      j = 0

      while j < posn.length && move_found == false

        if posn[j][0] == color
          piece = game_pieces.detect {|e| e.name == posn[j]}
          start_sq = j

          if piece.name[1] == 'k'
            piece.find_moves(game_pieces, posn, moves)
          else
            piece.find_moves(posn, moves)
          end

          piece.legal_moves.each do |e|
            posn = reset_game(game, board, posn, game_pieces)
            k = 0
            while k < new_moves.length
              temp_pc = game_pieces.detect {|e| e.name == new_moves[k][0]}
              end_sq, moves, posn = game.move(posn, temp_pc, new_moves[k][1], new_moves[k][2], details = '')
              k += 1
            end

            end_sq, moves, posn = game.move(posn, piece, start_sq, e, details = '')

            if game.pgn_list[-1] == pgn_list[i]
              move_found = true
              piece.square = end_sq
              piece.move_to_square(end_sq)
              new_moves << game.moves[-1]
              puts "new_moves: #{new_moves}"
              puts
            end

          end

        end
        j += 1
      end
      i += 1
      pgn_move = pgn_list[i]
      error = '... dev. stop at first castling move found' if pgn_move.include?('O')
      move_found = false
    end

    #error = 'test error'
    print_parsed(filename, list, info, pgn_list, error)

    # ----- fake return vales for development -------------
    data = 'fake data' # remember don't need to use game data when loading complete game
                       # (as game.rb will already be updated if load succesful, & reset if not)
                       # = need conditional somwhere in chess.rb &/or ui.rb to avoid this

    return data, error

  end

  def self.print_parsed(filename, list, info, pgn_list, error)
    if error == 'none'
      if info == nil || list.all? {|k, v| v == nil}
        title = "File: #{filename} (no details)"
      else
        title = "#{list['[white ']} v #{list['[black ']} (#{list['[event ']}, #{list['[date ']})"
      end
      # to do: shorten overly long title(s)... # ? do in ui.rb ? (return info in data?)
      puts "Title: #{title}"
      puts "Moves: #{pgn_list}"
      puts "---------------------------------------------------------------------------------------------------------"
    else
      puts "ERROR! (IN process_pgn) #{error}" # print error to load_save menu && do not load game
      puts "---------------------------------------------------------------------------------------------------------"
    end
  end

end
