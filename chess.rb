# chess.rb, by Simon Tharby, 2018
# A chess interface.
# Solution to final Ruby exercise, The odin project;
# https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project

require 'ruby2d'
require './ui'
require './pieces'
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

set title: "Chess - by Simon Tharby"
set width: 1280
set height: 720
set resizable: true

canvas = Image.new("img/ui/screen.png", height: 720, width: 1280, z: 0,
                        x: 0, y: 0, color: '#ffffff')

ui = UI.new
board = Board.new
game = Game.new(board.game_pieces)
ui.place_defaults
posn = board.posn

piece_lift = false
posn_pc = ""
start_square = nil
piece = nil
legal_list = []
promote = []

on :mouse_down do |event|
  if ui.menu == true
    ui.menu_event(event.x, event.y, 'click')
    if ui.new_game == true
      ui.new_game = false
      posn = Utilities.start_posn
      board.posn = posn
      board.new_game
      game_pieces = board.game_pieces
      game.reinitialize(game_pieces)
    end
  else
    location = board.mouse_square(event.x, event.y)
    if location != "off_board" && game.game_over == '' && promote == [] && ui.review == false
      location = 63 - location if board.flipped == true
      #startTime = Time.now # debug: monitor responsiveness
      posn_pc = posn[location]
      if posn_pc != "---"
        game_pieces = board.game_pieces
        piece = game_pieces.detect {|e| e.name == posn_pc}
        if game.to_move == piece.color
          piece_lift = true
          board.show_home_piece(posn_pc, location)
          start_square = location
          moves = game.moves
          if posn_pc[1] == 'k'
            piece.find_moves(game_pieces, posn, moves)
          else
            piece.find_moves(posn, moves)
          end
          legal_list = piece.legal_moves
          board.highlight_squares(legal_list) if ui.legal_sqs == true
        end
      end
      #puts "time to find legal squares: #{(duration = Time.now - startTime).to_s} s"
      #puts
    elsif promote != [] && board.promote.include?(location)
      piece.icon.z = -1
      promo_pawn = piece.name
      new_piece, details, location = board.select_promo_pc(location, posn, start_square)
      game.game_pieces = board.game_pieces
      end_sq, moves, posn = game.move(posn, new_piece, start_square, location, details, promo_pawn)
      ui.move_update(posn, board, game)
      end_sq = 63 - end_sq if board.flipped == true
      new_piece.move_to_square(end_sq)
      new_piece.icon.z = 3
      promote = []
    elsif location == "off_board"
      ui.event(event.x, event.y, 'click', posn, board, game)
    end
  end
end

on :mouse_move do |event|
  if ui.menu == true
    ui.menu_event(event.x, event.y, 'hover')
  else
    location = board.mouse_square(event.x, event.y)
    if piece_lift == true && promote == []
      location = 63 - location if board.flipped == true && location != "off_board"
      board.home_square.image.z = 4
      piece.set_posn(event.x - 40, event.y - 40)
      piece.icon.z = 10
    elsif promote != [] && board.promote.include?(location)
      board.promo_hover(location)
    elsif location == "off_board"
      ui.event(event.x, event.y, 'hover')
    end
  end
end

on :mouse_up do |event|
  if piece_lift == true
    piece_lift = false
    location = board.mouse_square(event.x, event.y)
    location = 63 - location if board.flipped == true && location != "off_board"

    board.unhighlight_squares(legal_list) if ui.legal_sqs == true
    if location != "off_board" && legal_list.include?(location) == true
      # startTime = Time.now # debug: monitor responsiveness
      if piece.name[1] == 'p' && (location < 8 || location > 55)
        promote = [piece.name, location]
        end_sq = location
        board.show_promo_pieces(promote)
      else
        details = ''
        end_sq, moves, posn = game.move(posn, piece, start_square, location, details)
        ui.move_update(posn, board, game)
      end
      board.start_end_squares(start_square, location)
      # puts "time to assess position: #{(duration = Time.now - startTime).to_s} s"
    else # == illegal move (reject)
      end_sq = start_square
    end

    board.hide_home_piece(posn_pc)
    end_sq = 63 - end_sq if board.flipped == true
    piece.move_to_square(end_sq)
    piece.icon.z = 5
  end

  # print_posn(posn) # debug output
end

on :key_down do |e|
  # To develop: keys for move list navigation
end

# puts
# print_posn(posn) # debug output

show
