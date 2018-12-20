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

  def self.test_read(filename)
    # test how to get specific data
    data = YAML::load_file("games/incomplete/#{filename}.yml") #Load

    g_p = data[:game][:game_pieces]
    piece = g_p.detect {|e| e.name == 'wn1'}
    puts "test read of wn1.square: #{piece.square}"
  end

  def self.list_files(dir, ext)
    ext == 'yml' ? split = 17 : split = 15
    list = Dir.glob("games/#{dir}/*.{#{ext},#{ext.upcase}}").map {|e| e[split..-1]}
    list = list.sort.reverse
  end

  def self.autosave(last_save, game)
    last_save = "games/incomplete/#{last_save}.yml"
    File.delete(last_save) if File.exists? last_save

    save_data = YAML.dump ({
      :game => {:moves => game.moves,
                :pgn_list => game.pgn_list,
                :game_pieces => game.game_pieces,
                :posn_list => game.posn_list}
    })

    filename = create_filename(incomplete = true)
    File.open("games/incomplete/#{filename}.yml", 'w'){|f| f.write(save_data)}

    #test_read(filename)

    filename
  end

  def self.load_file(filename)
    if filename.include?('incomplete')
      data = YAML::load_file("games/incomplete/#{filename}")
    else
      # however read a pgn file (probably line by line, as for text file)
    end
  end

end
