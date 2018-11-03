require './board'
require './pieces'

class Game
  attr_accessor :ply
  attr_reader :to_move
  attr_accessor :status
  attr_accessor :moves
  attr_accessor :checks
  attr_reader :check_blocks
  attr_reader :pins
  attr_accessor :game_over

  def initialize
    @ply = 0
    @to_move = 'white'
    @status = Text.new('Game in progress - move 1: White to move', x: 400,
      y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
    @moves = [] # [['piece', start_square, end_square, 'x?+?#?']]
    @pgn = ''
    @checks = 0
    @check_blocks = []
    @pinned = {}
    @game_over = ''
    @red_square = Board::HighLight_Sq.new(-1, 500, 500, [1.0, 0.0, 0.0, 0.7])
    @pc_taken = false
  end

  def set_side_to_move
    if @ply % 2 == 0
      @to_move = 'white'
    else
      @to_move = 'black'
    end
  end

  def pgn_square(square)
    file = Board::Coords[0][square % 8]
    rank = Board::Coords[1][(63 - square) / 8.floor]
    pgn_square = file + rank
  end

  def pgn_move(posn, piece, start_square, end_square, details = '')
    name = piece.name
    if details.include?('+') || details.include?('#')
      check_sym = details[-1]
      details = details[0..-2]
    end
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
    @pgn = @pgn + "#{n}#{pc}#{sq}#{check_sym} "
  end

  def move(game_pieces, posn, piece, start_square, end_square, details = '')
    def castle_move(start_sq, end_sq, name, game_pieces, posn)
      posn[start_sq] = '---'
      posn[end_sq] = name
      rook = game_pieces.detect {|e| e.name == name}
      rook.square = end_sq
      rook.move_to_square(end_sq)
    end

    # Update posn array, x,y of moved piece icon, hide icon of piece taken
    # (if any), and set @moved = true for moved piece
    posn_pc = posn[start_square]
    if (piece.name[1] == 'p' && piece.ep_square == end_square) ||
      posn[end_square] != '---' # piece taken, including en-passant
      @pc_taken = true
      if piece.name[1] == 'p' && piece.ep_square == end_square
        if piece.color == 'white' # piece taken en-passant
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
      end
      piece_to_take = game_pieces.detect {|e| e.name == piece_to_take}
      piece_to_take.icon.z = -1
    end
    x_pos, y_pos = Board.square_origin(end_square)
    posn[end_square] = posn_pc
    posn[start_square] = "---" # can crash, if piece taking not enabled
    piece.square = end_square
    piece.moved ||= true

    # --- Castling: make Rook move and set King @moved = true
    if piece.name[1] == 'k'
      if (start_square - end_square).abs == 2
        if end_square == 62
          castle_move(63, 61, 'wr1', game_pieces, posn)
        elsif end_square == 58
          castle_move(56, 59, 'wr0', game_pieces, posn)
        elsif end_square == 6
          castle_move(7, 5, 'br1', game_pieces, posn)
        elsif end_square == 2
          castle_move(0, 3, 'br0', game_pieces, posn)
        end
      end
      piece.moved = true
    end

    @ply += 1
    set_side_to_move

    if piece.checks > 0 # reset check vars, if move made (else checkmate already)
      @red_square.icon.z = -1
      game_pieces.each do |piece|
        if piece.name[0] == @to_move[0]
          piece.checks = 0
          piece.check_blocks = []
        end
      end
    end

    piece.ep_take_sq = -1 if piece.name[1] == 'p' && piece.ep_take_sq >= 0

    if @pinned != {}
      game_pieces.each do |piece|
        if @pinned.key?(piece.name)
          piece.pinned = {}
        end
      end
    end

    return x_pos, y_pos, @moves, posn
  end

  def assess_posn(game_pieces, posn, piece, start_square, end_square, details)
    @moves << [piece.name[0..1], start_square, end_square, details]
    if @to_move == 'white'
      king = game_pieces.detect {|e| e.name == 'wk0'}
    else
      king = game_pieces.detect {|e| e.name == 'bk0'}
    end
    @checks, @check_blocks, @pinned = king.checks_n_pins(game_pieces, posn)

    puts "checks: #{@checks}  block_sqs: #{@check_blocks}  pinned: #{@pinned}"
    puts

    if @checks > 0
      @red_square.set_origin(king.square)
      @red_square.icon.z = 2
      king.find_moves(game_pieces, posn)
      king_moves = king.legal_moves
      if @checks > 1
        puts "double check!" # DEBUG output
        if king_moves.length == 0
          @game_over = 'checkmate!'
        else
          game_pieces.each do |piece|
            piece.checks = @checks if piece.name[0] == @to_move[0]
          end
        end
      end
      if @checks == 1
        game_pieces.each do |piece|
          if piece.name[0] == @to_move[0]
            piece.checks = @checks
            piece.check_blocks = @check_blocks
          end
        end
        if king_moves.length == 0
          mate = true
          game_pieces.each do |piece|
            if piece.name[0] == @to_move[0] && piece.name[1] != 'k' && piece.icon.z > 0
              # puts "piece #{piece.name} legal: #{piece.legal_moves}" DEBUG output
              piece.find_moves(posn, @moves)
              mate = false if piece.legal_moves != []
            end
            break if mate == false
          end
        end
        @game_over = 'checkmate!' if mate == true
      end
    end

    if @pinned != {}
      game_pieces.each do |piece|
        if @pinned.key?(piece.name)
          piece.pinned = @pinned
        end
      end
    end

    if @pc_taken == true
      details = 'x'
      @pc_taken = false
    end

    if @checks > 0 && @game_over != 'checkmate!'
        details += '+'
    elsif @game_over == 'checkmate!'
        details += '#'
    end

    # ------- Castling: update, by removing option(s), if appropriate --------

    if @checks == 0
      if @to_move == 'white'
        king = game_pieces.detect {|e| e.name == 'wk0'}
      else
        king = game_pieces.detect {|e| e.name == 'bk0'}
      end

      if king.moved == false
        if @to_move == 'white'
          long_rook = game_pieces.detect {|e| e.name == 'wr0'}
          short_rook = game_pieces.detect {|e| e.name == 'wr1'}
        else
          long_rook = game_pieces.detect {|e| e.name == 'br0'}
          short_rook = game_pieces.detect {|e| e.name == 'br1'}
        end
        king.long = false if long_rook.moved == true || long_rook.icon.z < 0
        king.short = false if short_rook.moved == true || short_rook.icon.z < 0
      end
    end

    # ------------------------------------------------------------------------

    @moves[-1][3] = details
    pgn_move(posn, piece, start_square, end_square, details)

    # update status header
    @status.remove
    to_m = @to_move.capitalize
    @status = Text.new(
      "Game in progress - move #{(@ply + 2) / 2}: #{to_m} to move",
       x: 400, y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24,
       color: '#ffffff', z: 3)

    puts @pgn # debug (and later, for display)
    # p @moves
    # puts

    puts "#{@game_over}"
  end

end
