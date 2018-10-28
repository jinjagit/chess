# debug1.rb
# for testing / developing 'potential' moves of pieces
# potential moves == all legal moves when not constrained by other pieces
# nor the effects of other pieces (check, pins, etc.)

require 'ruby2d'
require './pieces'
require './position'
require './board'

def print_posn(posn)
  8.times do |i|
    8.times {|j| print "#{posn[8 * i + j]} "}
    print "\n"
  end
  puts
end

def print_all_pieces(all_pieces)
  all_pieces.each {|e| puts e.inspect}
  puts
end

set title: "debug1"
set width: 1280
set height: 720
set resizable: true

canvas = Rectangle.new(
  x: 0, y: 0,
  width: 1280,
  height: 720,
  color: '#000000', # true black
  z: 0)


all_pieces = []
piece_codes = {'p' => Pawn, 'r' => Rook, 'n' => Knight, 'b' => Bishop,
              'q' => Queen, 'k' => King}

Board.draw_board
posn = Position.get_posn('start')
Board.set_up_posn(all_pieces, posn, piece_codes)

on :key_down do |e|
  # All keyboard interaction
  case e.key
    when '1'
      new_posn = 'start'
    when '2'
      new_posn = 'two_pawns'
    when '3'
      new_posn = 'two_knights'
    when '4'
      new_posn = 'two_bishops'
    when '5'
      new_posn = 'two_rooks'
    when '6'
      new_posn = 'two_queens'
    when '7'
      new_posn = 'two_kings'
  end
  if e.key.to_i > 0 && e.key.to_i < 8
    Board.clear_pieces(all_pieces)
    posn = Position.get_posn(new_posn)
    Board.reset_posn(all_pieces, posn, piece_codes)
    print_posn(posn)
  end
end

puts
print_posn(posn)

show

# 'spare' pieces (12 = 1 of each class / color) have @name ending in 'x' and
# their icons are (will be) used as ghost pieces (on original square) when player
# attempts to move a posn_pc, and as icons on promotion menu (if pawn promoted)
