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
      filename = create_filename(incomplete = true) # conditional needed for complete case
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

  def self.load_file(filename)
    if filename.include?('incomplete') # ? change to .yml? (allow for renaming)
      data = YAML::load_file("games/incomplete/#{filename}")
    else
      data = File.read("games/complete/#{filename}")
    end
  end

end
