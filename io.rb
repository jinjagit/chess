module Io
  def self.create_filename(incomplete = true)
    t = Time.now
    t.hour < 10 ? hour = '0' + t.hour.to_s : hour = t.hour
    t.min < 10 ? min = '0' + t.min.to_s : min = t.min
    t.sec < 10 ? sec = '0' + t.sec.to_s : sec = t.sec

    if incomplete == false
      filename = "incomplete_#{t.year}-#{t.month}-#{t.day}_#{hour}h#{min}m#{sec}s"
    else
      filename = "incomplete_#{t.year}-#{t.month}-#{t.day}_#{hour}h#{min}m#{sec}s"
    end
  end


  def self.autosave
    dirname = "games"
    Dir.mkdir(dirname) unless File.exists?dirname
    dirname = "games/complete"
    Dir.mkdir(dirname) unless File.exists?dirname

    filename = create_filename(incomplete = true)
    puts filename
  end
end
