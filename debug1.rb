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
posn = Position.get_posn('start')
all_pieces = []
piece_codes = {'p' => Pawn, 'r' => Rook, 'n' => Knight, 'b' => Bishop,
              'q' => Queen, 'k' => King}

# set up position
posn.each_with_index do |posn_pc, square|
  if posn_pc != "--"
    n = all_pieces.count do |piece|
      piece.class == piece_codes[posn_pc[1]] && piece.color[0] == posn_pc[0]
    end
    name = "#{posn_pc}#{n}"
    if name[0] == "w"
      color = "white"
    else
      color = "black"
    end
    all_pieces << piece_codes[posn_pc[1]].new(name, color)
    posn[square] = name
    x_pos, y_pos = Board.square_origin(square)
    all_pieces[-1].set_posn(x_pos, y_pos)
    all_pieces[-1].set_layer(3)
  else
    posn[square] = "---" # just to make print look nicer ;-)
  end
end

puts
all_pieces.each {|e| puts e.inspect}
puts

8.times do |i|
  8.times {|j| print "#{posn[8 * i + j]} "}
  print "\n"
end

puts


show

# 'spare' pieces (12 = 1 of each class / color) have @name ending in 'x' and
# their icons are (will be) used as ghost pieces (on original square) when player
# attempts to move a posn_pc, and as icons on promotion menu (if pawn promoted)
