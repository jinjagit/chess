require './io'

def print_parsed(filename, list, info, pgn_list)
  if info == nil || list.all? {|k, v| v == nil}
    title = "File: #{filename} (no details)"
  else
    title = "#{list['[white ']} v #{list['[black ']} (#{list['[event ']}, #{list['[date ']})"
  end
  # to do: shorten overly long title(s)...
  puts "Title: #{title}"
  puts "Moves: #{pgn_list}"
  puts "---------------------------------------------------------------------------------------------------------"
end

def parse_pgn(data, filename)
  error = 'none'
  list = {'[event ' => nil, '[date ' => nil, '[white ' => nil, '[black ' => nil}
  info = nil
  title = ''
  pgn_list = ''

  begin
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
    end

  #rescue StandardError => error
    #error = 'cannot parse file contents'
  end

  unless error == 'none'
    puts "ERROR! #{error}" # print error to load_save menu && do not load game
    puts "---------------------------------------------------------------------------------------------------------"
  else # parse data components
    print_parsed(filename, list, info, pgn_list)
    # to do:
      # quick check of length of each pgn move
      # regex moves for illegal chars / formats
      # test moves for legality...
  end
end



system "clear"
files = ['test1.pgn', 'uppercase_ext.PGN', 'no_info.pgn',
        'lichess_pgn_2018.12.21_Human_vs_Human.ozTcKlq3.pgn',
        'spassky_fischer_1972.pgn', 'extra_spaces.pgn', 'move_too_short.pgn',
        'move_too_long.pgn', 'bad_result.pgn', 'small_halves.pgn']

files.each do |filename|
  puts "loading: #{filename}"
  puts
  data, error = Io.load_file(filename)
  parse_pgn(data, filename)
end
