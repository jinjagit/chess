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

  def self.mk_dir(incomplete = true)
    dirname = "games"
    Dir.mkdir(dirname) unless File.exists? dirname
    if incomplete == true
      dirname = "games/incomplete"
      Dir.mkdir(dirname) unless File.exists? dirname
    else
      dirname = "games/complete"
      Dir.mkdir(dirname) unless File.exists? dirname
    end
  end

  def self.autosave(last_save)
    last_save = "games/incomplete/#{last_save}.txt"
    puts last_save
    mk_dir(incomplete = true)
    File.delete(last_save) if File.exists? last_save
    filename = create_filename(incomplete = true)
    File.open("games/incomplete/#{filename}.txt", 'w'){|f| f.write("My name is: #{filename}")}
    filename
  end
end
