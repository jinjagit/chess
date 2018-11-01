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
      if details == 'x'
        pc = pgn_square(start_square)[0] + 'x'
      else
        pc = ''
      end
    end
    sq = pgn_square(end_square)
    @pgn = @pgn + "#{n}#{pc}#{sq} "
  end

  def move_made(posn, piece, start_square, end_square, details = '')
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
    @status.remove
    to_m = @to_move.capitalize
    @status = Text.new(
      "Game in progress - move #{(@ply + 2) / 2}: #{to_m} to move",
       x: 400, y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24,
       color: '#ffffff', z: 3)
    # p @pgn # debug (and later, for display)
    p @moves
    @moves
  end

end
