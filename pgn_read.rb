require './io'

def parse_pgn(filename)
  error = 'none'

  begin
    puts "loading: #{filename}"
    data = Io.load_file(filename)
    puts "data from #{filename}:"
    p data
    puts
  rescue StandardError => error
    puts "ERROR! #{error}" unless error == 'none'
  end

end


files = ['test1.pgn', 'does_not_exist.pgn']

files.each {|filename| parse_pgn(filename)}
puts
puts "I am still running after error :-)"
