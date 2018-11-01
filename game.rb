require './board'
require './pieces'

class Game
  attr_accessor :ply
  attr_reader :to_move
  attr_accessor :status
  attr_accessor :moves

  def initialize
    @ply = 0
    @to_move = 'white'
    @status = Text.new('Game in progress - move 1: White to move', x: 400,
      y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
    @moves = [] # [['piece', start_square, end_square, 'x?+?#?']]
    @pgn = ''
  end

  def pgn_square(square)
    file = Board::Coords[0][square % 8]
    rank = Board::Coords[1][(63 - square) / 8.floor]
    pgn_square = file + rank
  end

  def pgn_move(posn, piece, start_square, end_square, details)
    name = piece.name
    if @to_move == 'black'
      n = "#{(@ply + 2) / 2}. "
    else
      n = ""
    end
    if name[1] != 'p'
      pc = name[1].upcase + details
      if pc[0] != 'K' ## == R, B, N, or Q
        piece.find_moves(posn)
        if piece.disambiguate != []
          dis_list = [pgn_square(start_square)]
          piece.disambiguate.each {|e| dis_list << pgn_square(e)}
          same_file, same_rank = false, false
          dis_list.each do |elem|
            same_file = true if dis_list.count {|e| e[0] == elem[0]} > 1
            same_rank = true if dis_list.count {|e| e[1] == elem[1]} > 1
          end
          if same_file == true && same_rank == true
            pc = pc + dis_list[0]
          elsif same_file == true
            pc = pc + dis_list[0][1]
          else
            pc = pc + dis_list[0][0]
          end
        end
      end
    else
      if details.include? 'x'
        pc = pgn_square(start_square)[0] + 'x'
      else
        pc = ''
      end
    end
    sq = pgn_square(end_square)
    @pgn = @pgn + "#{n}#{pc}#{sq} "
  end

  def move(game_pieces, posn, piece, start_square, end_square, details = '')
    posn_pc = posn[start_square]
    if (piece.name[1] == 'p' && piece.ep_square == end_square) ||
      posn[end_square] != '---' # piece taken, including en-passant
      if piece.name[1] == 'p' && piece.ep_square == end_square
        if piece.color == 'white' # piece take en-passant
          piece_to_take = posn[end_square + 8]
          posn[end_square + 8] = '---'
        else
          piece_to_take = posn[end_square - 8]
          posn[end_square - 8] = '---'
        end
        piece.ep_square = -1
        details = 'xep'
      else # == piece taken, not en-passant
        piece_to_take = posn[end_square]
        details = 'x'
      end
      piece_to_take = game_pieces.detect {|e| e.name == piece_to_take}
      piece_to_take.icon.z = -1
    end
    x_pos, y_pos = Board.square_origin(end_square)
    posn[end_square] = posn_pc
    posn[start_square] = "---" # can crash, if piece taking not enabled
    piece.square = end_square
    piece.moved ||= true

    name = piece.name
    @ply += 1
    if @ply % 2 == 0
      @to_move = 'white'
    else
      @to_move = 'black'
    end

    # add to move list(s):
    @moves << [name[0..1], start_square, end_square, details]
    pgn_move(posn, piece, start_square, end_square, details)

    # update status header
    @status.remove
    to_m = @to_move.capitalize
    @status = Text.new(
      "Game in progress - move #{(@ply + 2) / 2}: #{to_m} to move",
       x: 400, y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24,
       color: '#ffffff', z: 3)

    p @pgn # debug (and later, for display)
    # p @moves
    puts
    return x_pos, y_pos, @moves, posn
  end

end
