require './pieces'

# layout of new game start:
layout = ['br', 'bn', 'bb', 'bq', 'bk', 'bb', 'bn', 'br',
          'bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp',
          '--', '--', '--', '--', '--', '--', '--', '--',
          '--', '--', '--', '--', '--', '--', '--', '--',
          '--', '--', '--', '--', '--', '--', '--', '--',
          '--', '--', '--', '--', '--', '--', '--', '--',
          'wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp',
          'wr', 'wn', 'wb', 'wq', 'wk', 'wb', 'wn', 'wr']

all_pieces = []
piece_codes = {'p' => Pawn, 'r' => Rook, 'n' => Knight, 'b' => Bishop,
              'q' => Queen, 'k' => King}


layout.each_with_index do |e, i|
  if e != "--"
    n = all_pieces.count do |elem|
      elem.class == piece_codes[e[1]] && elem.color[0] == e[0]
    end
    if e[0] == "w"
      color = "white"
    else
      color = "black"
    end
    all_pieces << piece_codes[e[1]].new("#{e}#{n}", color)
    layout[i] = "#{e}#{n}"
  else
    layout[i] = "---"
  end
end

puts
all_pieces.each {|e| puts e.inspect}
puts

8.times do |i|
  8.times {|j| print "#{layout[8 * i + j]} "}
  print "\n"
end

puts
