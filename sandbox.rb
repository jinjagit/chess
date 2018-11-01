# sandbox.rb
# for testing / developing 'potential' & 'legal' moves of pieces
# potential moves == all legal moves, including constraints of other pieces,
# but not yet including the effects of other pieces (check, pins, etc.)

require 'ruby2d'
require './ui'
require './pieces'
require './position'
require './board'
require './game'

# ---------------- print routines for debugging --------------------
def print_posn(posn)
  8.times do |i|
    8.times {|j| print "#{posn[8 * i + j]} "}
    print "\n"
  end
  puts
end

def print_game_pieces(game_pieces)
  game_pieces.each {|e| puts e.inspect}
  puts
end
# ------------------------------------------------------------------

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

game_pieces = []
moves = []
spare_pieces = Board.create_spare_pieces
ui = UI.new
game = Game.new
highlight_sqs = Board.draw_board(ui.coords)
posn = Position.get_posn('start')
Board.set_up_posn(game_pieces, posn, first_run = true)

piece_lift = false
posn_pc = ""
start_square = nil
piece = nil
legal_list = []

on :mouse_down do |event|
  startTime = Time.now # debug: monitor responsiveness
  location = Board.mouse_square(event.x, event.y)
  if location != "off_board"
    posn_pc = posn[location]
    if posn_pc != "---"
      piece = game_pieces.detect {|e| e.name == posn_pc}
      if game.to_move == piece.color
        piece_lift = true
        start_square = location
        piece.find_moves(posn, moves)
        legal_list = piece.legal_moves
        Board.highlight_squares(legal_list, highlight_sqs)
      end
    end
  end
  puts "time to find legal squares: #{(duration = Time.now - startTime).to_s} s"
  puts
end

on :mouse_move do |event|
  if piece_lift == true
    location = Board.mouse_square(event.x, event.y)
    piece.set_posn(event.x - 40, event.y - 40)
    piece.icon.z = 10
  end
end

on :mouse_up do |event|
  if piece_lift == true
    piece_lift = false
    location = Board.mouse_square(event.x, event.y)
    Board.unhighlight_squares(legal_list, highlight_sqs)
    if location != "off_board" && legal_list.include?(location) == true
    details = ''
      x_pos, y_pos, moves, posn = game.move(game_pieces, posn, piece, start_square, location, details)
    else # == illegal move (reject)
      x_pos, y_pos = Board.square_origin(start_square)
    end

    piece.set_posn(x_pos, y_pos)
    piece.icon.z = 3
  end

  # print_posn(posn) # debug output
end

on :key_down do |e|
  # Select sandbox position(s)
  case e.key
    when '1'
      new_posn = 'start'
    when '2'
      new_posn = 'pawns'
    when '3'
      new_posn = 'rooks'
    when '4'
      new_posn = 'knights'
    when '5'
      new_posn = 'bishops'
    when '6'
      new_posn = 'queens'
    when '7'
      new_posn = 'two_kings'
    when '8'
      new_posn = 'game'
  end
  if e.key.to_i > 0 && e.key.to_i < 9
    Board.clear_pieces(game_pieces)
    game.status.remove
    game = Game.new
    posn = Position.get_posn(new_posn)
    Board.set_up_posn(game_pieces, posn, first_run = false)
    print_posn(posn)
  end
end

puts
print_posn(posn) # debug output

show
