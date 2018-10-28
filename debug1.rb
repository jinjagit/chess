# debug1.rb
# for testing / developing 'potential' moves of pieces
# potential moves == all legal moves when not constrained by other pieces
# nor the effects of other pieces (check, pins, etc.)

require 'ruby2d'
require './pieces'
require './position'
require './board'

set title: "debug1"
set width: 1280
set height: 720
set resizable: true

canvas = Rectangle.new(
  x: 0, y: 0,
  width: 1280,
  height: 720,
  color: '#000000', # true black
  z: 0
)

Board.draw_board

layout = Position.get_posn('start')

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
    layout[i] = "---" # just to make print look nicer ;-)
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


show

# 'spare' pieces (12 = 1 of each class / color) have @name ending in 'x' and
# their icons are (will be) used as ghost pieces (on original square) when player
# attempts to move a piece, and as icons on promotion menu (if pawn promoted)
