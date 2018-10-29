# sandbox.rb
# for testing / developing 'potential' & 'legal' moves of pieces
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

set title: "chess sandbox"
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

highlight_sqs = Board.draw_board
posn = Position.get_posn('start')
Board.set_up_posn(all_pieces, posn, piece_codes, first_run = true)

piece_lift = false
posn_pc = ""
start_square = nil
piece = nil
full_screen = false
highlight_list = []

on :mouse_down do |event|
  location = Board.mouse_square(event.x, event.y)
  posn_pc = posn[location]
  if posn_pc != "---"
    piece = all_pieces.detect {|e| e.name == posn_pc}
    piece_lift = true
    start_square = location
    piece.find_moves
    highlight_list = piece.legal_moves
    Board.highlight_squares(highlight_list, highlight_sqs)
  end
end

on :mouse_move do |event|
  if piece_lift == true
    location = Board.mouse_square(event.x, event.y)
    piece.set_posn(event.x - 40, event.y - 40)
    piece.set_layer(10)
  end
end

on :mouse_up do |event|
  if piece_lift == true
    piece_lift = false
    location = Board.mouse_square(event.x, event.y)
    if location != "off_board" && location != start_square
      x_pos, y_pos = Board.square_origin(location)
      posn[location] = posn_pc
      posn[start_square] = "---" # can crash, while piece taking not enabled
      piece.square = location
    else
      x_pos, y_pos = Board.square_origin(start_square)
    end

    Board.unhighlight_squares(highlight_list, highlight_sqs)
    piece.set_posn(x_pos, y_pos)
    piece.set_layer(3)
  end
end

on :key_down do |e|
  # Select sandbox position(s)
  case e.key
    when '1'
      new_posn = 'start'
    when '2'
      new_posn = 'two_pawns'
    when '3'
      new_posn = 'four_rooks'
    when '4'
      new_posn = 'four_knights'
    when '5'
      new_posn = 'four_bishops'
    when '6'
      new_posn = 'two_queens'
    when '7'
      new_posn = 'two_kings'
  end
  if e.key.to_i > 0 && e.key.to_i < 8
    Board.clear_pieces(all_pieces)
    posn = Position.get_posn(new_posn)
    Board.set_up_posn(all_pieces, posn, piece_codes)
    print_posn(posn)
  end
end

puts
print_posn(posn)

show
