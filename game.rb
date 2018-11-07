require 'ruby2d'
require 'digest'
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
  attr_accessor :game_pieces
  attr_accessor :ui_data

  def initialize(game_pieces)
    @ply = 0
    @to_move = 'white'
    @status = Text.new('Game in progress - move 1: White to move', x: 400,
      y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
    @moves = [] # [['piece', start_square, end_square, 'x,+,#,O-O, etc.']]
    @pgn = ''
    @checks = 0
    @check_blocks = []
    @pinned = {}
    @game_over = ''
    @game_pieces = game_pieces
    @red_square = HighLight_Sq.new(-1, 0, 0, [1.0, 0.0, 0.0, 0.7])
    @checksums = []
    @checksum_dbls = {}
    @threefold = []
    @w_material = 39
    @b_material = 39
    @ui_data = []
  end

  def remove_red_sq
    @red_square.image.remove
  end

  def set_side_to_move
    if @ply % 2 == 0
      @to_move = 'white'
    else
      @to_move = 'black'
    end
  end

  def pgn_square(square)
    file = Utilities::Coords[0][square % 8]
    rank = Utilities::Coords[1][(63 - square) / 8.floor]
    pgn_square = file + rank
  end

  def pgn_move(posn, piece, start_square, end_square, details = '')
    promote = ''
    name = piece.name
    if details.include?('=')
      if details.include?('x')
        promote = details[1..2]
        details = 'x' + details[3..-1]
      else
        promote = details[0..1]
        details = details[2..-1]
      end
    end
    if details.include?('+')
      suffix = details[-1]
      details = details[0..-2]
    elsif details.include?('#')
      suffix = '# ' + details[-3..-1]
      details = details[0..-5]
    elsif details.include?('1/2-1/2')
      suffix = ' 1/2-1/2'
      details = details[0..-8]
    end
    if @to_move == 'black'
      n = "#{(@ply + 2) / 2}. "
    else
      n = ""
    end
    if name[1] != 'p' && promote == ''
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
    sq = '' if details.include? 'O'
    pc = details if details.include? 'O'
    @pgn = @pgn + "#{n}#{pc}#{sq}#{promote}#{suffix} "
  end

  def move(posn, piece, start_square, end_square, details = '')
    def castle_move(start_sq, end_sq, name, posn)
      posn[start_sq] = '---'
      posn[end_sq] = name
      rook = @game_pieces.detect {|e| e.name == name}
      rook.square = end_sq
      rook.move_to_square(end_sq)
    end

    def no_moves(posn)
      result = true
      @game_pieces.each do |piece|
        if piece.name[0] == @to_move[0] && piece.name[1] != 'k' && piece.icon.z > 0
          # puts "piece #{piece.name} legal: #{piece.legal_moves}" DEBUG output
          piece.find_moves(posn, @moves)
          result = false if piece.legal_moves != []
        end
        break if result == false
      end
      result
    end

    def subtract_material(piece)
      if piece.name[1] == 'p'
        loss = 1
      elsif piece.name[1] == 'r'
        loss = 5
      elsif piece.name[1] == 'q'
        loss = 9
      else
        loss = 3
      end

      if piece.name[0] == 'w'
        @w_material -= loss
      else
        @b_material -= loss
      end
    end

    def add_material(details)
      if details[-1] == 'Q'
        gain = 8
      elsif details[-1] == 'R'
        gain = 4
      else
        gain = 2
      end

      if @to_move[1] == 'w'
        @b_material += gain
      else
        @w_material += gain
      end
    end

    def update_status_msg
      @status.remove
      to_m = @to_move.capitalize
      if @game_over == ''
        @status = Text.new(
          "Game in progress - move #{(@ply + 2) / 2}: #{to_m} to move",
           x: 400, y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24,
           color: '#ffffff', z: 3)
       elsif @game_over == 'checkmate!'
         if to_m == 'White'
           to_m = 'Black'
         else
           to_m = 'White'
         end
         @status = Text.new(
           "   Game over! #{to_m} wins by checkmate", x: 400, y: 8,
           font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
       elsif @game_over == 'stalemate!'
         @status = Text.new(
           "      Game over! Draw by stalemate", x: 400, y: 8,
           font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
       elsif @game_over == 'insufficient!'
         @status = Text.new(
           "Game over! Draw by insufficient material", x: 400, y: 8,
           font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
       elsif @game_over == '50-move rule!'
         @status = Text.new(
           "   Game over! Draw by 50-move rule", x: 400, y: 8,
           font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
       elsif @game_over == '3-fold repetition!'
         @status = Text.new(
           "  Game over! Draw by 3-fold repetition", x: 400, y: 8,
           font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
       end
    end

    # Update posn array, square of moved piece icon, hide icon of piece taken
    # (if any), and set @moved = true for moved piece
    posn_pc = posn[start_square]
    if (piece.name[1] == 'p' && piece.ep_square == end_square) ||
      posn[end_square] != '---' # == piece taken
      details = 'x' + details
      if piece.name[1] == 'p' && piece.ep_square == end_square
        if piece.color == 'white' # == piece taken en-passant
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
      piece_to_take = @game_pieces.detect {|e| e.name == piece_to_take}
      piece_to_take.icon.z = -1
      subtract_material(piece_to_take)
    end
    posn[end_square] = posn_pc
    posn[start_square] = "---"
    piece.square = end_square
    piece.moved ||= true

    if details.include?('=') # pawn was promoted
      posn[end_square] = piece.name
      add_material(details)
    end

    if piece.name[1] == 'k' # castling (move the rook), set King to 'has moved'
      if (start_square - end_square).abs == 2
        if end_square == 62
          castle_move(63, 61, 'wr1', posn)
        elsif end_square == 58
          castle_move(56, 59, 'wr0', posn)
        elsif end_square == 6
          castle_move(7, 5, 'br1', posn)
        elsif end_square == 2
          castle_move(0, 3, 'br0', posn)
        end
        details += 'O-O' if (end_square == 6 || end_square == 62)
        details += 'O-O-O' if (end_square == 2 || end_square == 58)
      end
      piece.moved = true
    end

    if piece.checks > 0 # reset check vars, if move made (else checkmate already)
      @red_square.image.z = -1
      @game_pieces.each do |piece|
        if piece.name[0] == @to_move[0]
          piece.checks = 0
          piece.check_blocks = []
        end
      end
    end

    @ply += 1
    set_side_to_move

    piece.ep_take_sq = -1 if piece.name[1] == 'p' && piece.ep_take_sq >= 0

    if @pinned != {}
      @game_pieces.each do |piece|
        if @pinned.key?(piece.name)
          piece.pinned = {}
        end
      end
    end

    @moves << [piece.name[0..1], start_square, end_square, details]

    # --- assess resulting position (most of remaining code in this def) ---

    # assess draw by: 50 move rule or 3-fold repetition of position
    if details.include?('x') || piece.name[1] == 'p'
      @checksums = []
      @checksum_dbls = {}
    else
      string = posn.join
      @checksums << Digest::SHA2.hexdigest(string)
    end

    @game_over = "50-move rule!" if @checksums.length >= 100

    if @ply >= 5 && @checksums.length >= 3
      if @checksum_dbls.length > 0
        if @checksum_dbls.key?(@checksums[-1])
          @game_over = "3-fold repetition!"
          @threefold = @checksum_dbls["#{@checksums[-1]}"]
          @threefold << @ply
        end
      end
      @checksums[0...-1].each_with_index do |e, i|
        @checksum_dbls[@checksums[-1]] = [i, @ply] if e == @checksums[-1]
      end
    end

    material = {'n' => 0, 'b' => 0, 'other' => 0} # insufficient material?

    @game_pieces.each do |e|
      material['n'] += 1 if e.icon.z > 0 && e.name[1] == 'n'
      material['b'] += 1 if e.icon.z > 0 && e.name[1] == 'b'
      material['other'] += 1 if e.icon.z > 0 && e.name[1] != 'n' &&
        e.name[1] != 'b' && e.name[1] != 'k'
    end

    @game_over = "insufficient!" if material['n'] == 1 && material['b'] == 0 &&
      material['other'] == 0
    @game_over = "insufficient!" if material['b'] == 1 && material['n'] == 0 &&
      material['other'] == 0
    if material['b'] > 1 && material['n'] == 0 && material['other'] == 0
      square_color = []
      @game_pieces.each do |e|
        if e.icon.z > 0 && e.name[1] == 'b'
          square_color << (((e.square / 8.floor) + e.square) % 2)
        end
      end
      @game_over = "insufficient!" if square_color.all? {|e| e == 0}
      @game_over = "insufficient!" if square_color.all? {|e| e == 1}
    end

    if @to_move == 'white' # assess checks (including possible blocking & pins)
      king = @game_pieces.detect {|e| e.name == 'wk0'}
    else
      king = @game_pieces.detect {|e| e.name == 'bk0'}
    end
    @checks, @check_blocks, @pinned = king.checks_and_pins(@game_pieces, posn)

    # puts "checks: #{@checks}  block_sqs: #{@check_blocks}  pinned: #{@pinned}"
    # puts # DEBUG output -----------

    king.find_moves(@game_pieces, posn)
    king_moves = king.legal_moves

    if checks == 0 && king_moves.length == 0
      @game_over = 'stalemate!' if no_moves(posn) == true
    end

    if @checks > 0
      @red_square.set_origin(king.square)
      @red_square.image.z = 2
      if @checks > 1
        puts "double check!" # DEBUG output
        if king_moves.length == 0
          @game_over = 'checkmate!'
        else
          @game_pieces.each do |piece|
            piece.checks = @checks if piece.name[0] == @to_move[0]
          end
        end
      end
      if @checks == 1
        @game_pieces.each do |piece|
          if piece.name[0] == @to_move[0]
            piece.checks = @checks
            piece.check_blocks = @check_blocks
          end
        end
        if king_moves.length == 0
          @game_over = 'checkmate!' if no_moves(posn) == true
        end
      end
    end

    if @pinned != {}
      @game_pieces.each do |piece|
        if @pinned.key?(piece.name)
          piece.pinned = @pinned
        end
      end
    end

    if @checks > 0 && @game_over != 'checkmate!'
        details += '+'
    elsif @game_over == 'checkmate!'
      if @to_move == 'white'
        details += '#0-1'
      else
        details += '#1-0'
      end
    elsif @game_over == 'stalemate!' || @game_over == 'insufficient!' ||
          @game_over == '50-move rule!' || game_over == '3-fold repetition!'
      details += '1/2-1/2'
    end

    if @checks == 0 # update castling options, if rook moved or was taken
      if @to_move == 'white'
        king = @game_pieces.detect {|e| e.name == 'wk0'}
      else
        king = @game_pieces.detect {|e| e.name == 'bk0'}
      end
      if king.moved == false
        if @to_move == 'white'
          long_rook = @game_pieces.detect {|e| e.name == 'wr0'}
          short_rook = @game_pieces.detect {|e| e.name == 'wr1'}
        else
          long_rook = @game_pieces.detect {|e| e.name == 'br0'}
          short_rook = @game_pieces.detect {|e| e.name == 'br1'}
        end
        king.long = false if long_rook.moved == true || long_rook.icon.z < 0
        king.short = false if short_rook.moved == true || short_rook.icon.z < 0
      end
    end

    @moves[-1][3] = details # add move details to move list(s)
    pgn_move(posn, piece, start_square, end_square, details)
    update_status_msg
    @ui_data = [@ply, @w_material, @b_material]

    puts
    puts @pgn # debug (and later, for display)
    # p @moves

    # puts "#{@game_over}"

    return end_square, @moves, posn
  end
end
