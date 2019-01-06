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

  def self.list_files(dir, incomplete = true)
    incomplete == true ? split = 17 : split = 15
    list = Dir.glob("games/#{dir}/*.yml").map {|e| e[split..-1]}
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

  def self.save(game, board)
    save_data = create_yaml(game, board)
    if game.game_over == ''
      filename = create_filename(incomplete = true)
      File.open("games/incomplete/#{filename}.yml", 'w'){|f| f.write(save_data)}
    else
      filename = create_filename(incomplete = false)
      File.open("games/complete/#{filename}.yml", 'w'){|f| f.write(save_data)}
    end
    filename
  end

  def self.autosave(last_save, game, board)
    last_save = "games/incomplete/#{last_save}.yml"
    File.delete(last_save) if File.exists? last_save
    save(game, board)
  end

  def self.load_file(filename, game, board, error = 'none')
    data = nil
    begin
      if filename[0] == 'i'
        data = YAML::load_file("games/incomplete/#{filename}")
      elsif filename[0] == 'c'
        data = YAML::load_file("games/complete/#{filename}")
      end
    rescue StandardError => error
      error = 'cannot open file (check permissions)'
    end
    
    return data, error
  end

end
