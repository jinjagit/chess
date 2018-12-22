require './io'

def parse_pgn(data)
  error = 'none'
  event = nil
  date = nil
  white = nil
  black = nil
  result = nil
  info = nil
  pgn_list = ['Nf3', 'e5']

  begin
    print "data in: "
    p data
    puts
    temp = data.strip.split("\n")
    info = temp[0..-2]
    pgn_list = temp[-1]
  rescue StandardError => error
  end

  unless error == 'none'
    puts "ERROR! #{error}" unless error == 'none' # open error window & print
  else # parse data components and then test moves for legality
    print "Event: #{event}  "
    print "Date: #{date}  "
    print "White: #{white}  "
    print "Black: #{black}  "
    puts "Result: #{result}  "
    puts "info: #{info}"
    puts "Moves: #{pgn_list}"
    puts "---------------------------------------------------------------------------------------------------------"
  end


end

system "clear"
files = ['test1.pgn', 'uppercase_ext.PGN', 'lichess_pgn_2018.12.21_Human_vs_Human.ozTcKlq3.pgn']

files.each do |filename|
  puts "loading: #{filename}"
  data = Io.load_file(filename)
  parse_pgn(data)
end

puts
puts "I am still running, even after error :-)"
