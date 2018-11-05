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

ui = UI.new
board = Board.new
game = Game.new(board.game_pieces)
posn = board.posn
moves = []

piece_lift = false
posn_pc = ""
start_square = nil
piece = nil
legal_list = []
promote = []

on :mouse_down do |event|
  location = board.mouse_square(event.x, event.y)
  if location != "off_board" && game.game_over == '' && promote == []
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
  elsif promote != [] && board.promote.include?(location)
    piece.icon.z = -1
    new_piece, details, location = board.select_promo_pc(location, posn, start_square)
    game.game_pieces = board.game_pieces
    end_sq, moves, posn = game.move(posn, new_piece, start_square, location, details)
    new_piece.move_to_square(end_sq)
    new_piece.icon.z = 3
    promote = []
  end
end

on :mouse_move do |event|
  if piece_lift == true && promote == []
    location = board.mouse_square(event.x, event.y)
    board.home_square.image.z = 4
    piece.set_posn(event.x - 40, event.y - 40)
    piece.icon.z = 10
  elsif promote != []
    location = board.mouse_square(event.x, event.y)
    if board.promote.include?(location)
      board.promo_hover(location)
    end
  end
end

on :mouse_up do |event|
  if piece_lift == true
    # startTime = Time.now # debug: monitor responsiveness
    piece_lift = false
    location = board.mouse_square(event.x, event.y)
    board.unhighlight_squares(legal_list)
    if location != "off_board" && legal_list.include?(location) == true
      if piece.name[1] == 'p' && (location < 8 || location > 55)
        promote = ['on', location]
        end_sq = location
        board.show_promo_pieces(promote)
      else
        details = ''
        end_sq, moves, posn = game.move(posn, piece, start_square, location, details)
      end
    board.start_end_squares(start_square, location)
    else # == illegal move (reject)
    end_sq = start_square
    end

    board.hide_home_piece(posn_pc)
    piece.move_to_square(end_sq)
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
      new_posn = 'pro_mate'
    when '9'
      new_posn = 'promote'
  end
  if e.key.to_i > 0 && e.key.to_i < 10
    board.clear_pieces
    game.status.remove
    posn = Position.get_posn(new_posn)
    board.posn = posn
    board.hide_start_end
    board.set_up_posn(first_run = false)
    game.remove_red_sq
    game = Game.new(board.game_pieces)
    print_posn(posn)
  end
end

puts
print_posn(posn) # debug output

show
