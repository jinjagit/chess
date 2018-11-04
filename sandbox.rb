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

moves = []
ui = UI.new
board = Board.new
game = Game.new(board.game_pieces)
posn = board.posn

piece_lift = false
posn_pc = ""
start_square = nil
piece = nil
legal_list = []

on :mouse_down do |event|
  location = board.mouse_square(event.x, event.y)
  if location != "off_board" && game.game_over == ''
    #startTime = Time.now # debug: monitor responsiveness
    posn_pc = posn[location]
    if posn_pc != "---"
      game_pieces = board.game_pieces
      piece = game_pieces.detect {|e| e.name == posn_pc}
      if game.to_move == piece.color
        piece_lift = true
        board.show_home_piece(posn_pc, location)
        start_square = location
        if posn_pc[1] == 'k'
          piece.find_moves(game_pieces, posn, moves)
        else
          piece.find_moves(posn, moves)
        end
        legal_list = piece.legal_moves
        board.highlight_squares(legal_list)
      end
    end
    #puts "time to find legal squares: #{(duration = Time.now - startTime).to_s} s"
    #puts
  end
end

on :mouse_move do |event|
  if piece_lift == true
    location = board.mouse_square(event.x, event.y)
    board.home_square.icon.z = 4
    piece.set_posn(event.x - 40, event.y - 40)
    piece.icon.z = 10
  end
end

on :mouse_up do |event|
  if piece_lift == true
    # startTime = Time.now # debug: monitor responsiveness
    piece_lift = false
    location = board.mouse_square(event.x, event.y)
    board.unhighlight_squares(legal_list)
    if location != "off_board" && legal_list.include?(location) == true
    details = ''
      x_pos, y_pos, moves, posn = game.move(posn, piece, start_square, location, details)
      board.start_end_squares(start_square, location)
      # puts "time to evaluate position: #{(duration = Time.now - startTime).to_s} s"
      # puts
    else # == illegal move (reject)
      x_pos, y_pos = Tools.square_origin(start_square)
    end

    board.hide_home_piece(posn_pc)
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
      new_posn = 'dbl_checks'
    when '3'
      new_posn = 'castling'
    when '4'
      new_posn = 'crash'
    when '5'
      new_posn = 'bishops'
    when '6'
      new_posn = 'queens'
    when '7'
      new_posn = 'stalemate'
    when '8'
      new_posn = 'checks'
    when '9'
      new_posn = 'promote'
  end
  if e.key.to_i > 0 && e.key.to_i < 10
    board.clear_pieces
    game.status.remove
    posn = Position.get_posn(new_posn)
    board = Board.new(posn)
    game = Game.new(board.game_pieces)
    print_posn(posn)
  end
end

puts
print_posn(posn) # debug output

show
