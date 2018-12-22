require './io'

def parse_pgn(filename)
  error = 'none'

  begin
    puts
    puts "loading: #{filename}"
    data = Io.load_file(filename)
    puts "data from #{filename}:"
    p data
  rescue StandardError => error
    puts "ERROR! #{error}" unless error == 'none'
  end

end


files = ['test1.pgn', 'does_not_exist.pgn', 'uppercase_ext.PGN']

files.each {|filename| parse_pgn(filename)}
puts
puts "I am still running after error :-)"
