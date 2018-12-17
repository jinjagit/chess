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

  def self.mk_dir
    dirname = "games"
    Dir.mkdir(dirname) unless File.exists? dirname
    dirname = "games/incomplete"
    Dir.mkdir(dirname) unless File.exists? dirname
    dirname = "games/complete"
    Dir.mkdir(dirname) unless File.exists? dirname
  end

  def self.test_read(filename)
    # test how to get specific data
    data = YAML::load_file("games/incomplete/#{filename}.yml") #Load

    g_p = data[:game][:game_pieces]
    piece = g_p.detect {|e| e.name == 'wn1'}
    puts "test read of wn1.square: #{piece.square}"
  end

  def self.autosave(last_save, game)
    last_save = "games/incomplete/#{last_save}.yml"
    File.delete(last_save) if File.exists? last_save

    save_data = YAML.dump ({
      :game => {:moves => game.moves,
                :pgn_list => game.pgn_list,
                :game_pieces => game.game_pieces}
    })

    filename = create_filename(incomplete = true)
    File.open("games/incomplete/#{filename}.yml", 'w'){|f| f.write(save_data)}

    #test_read(filename)

    filename
  end
end
