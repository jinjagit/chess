class Piece
  attr_reader :color
  attr_reader :name
  attr_accessor :icon
  attr_accessor :square
  attr_accessor :legal_moves
  attr_accessor :moved
  attr_accessor :checks
  attr_accessor :check_blocks
  attr_accessor :pinned

  def initialize(name, color, square)
    @name = name
    @color = color
    @square = square
    @legal_moves = []
    @moved = false
    @checks = 0
    @check_blocks = []
    @pinned = {}
  end

  def set_posn(x, y)
    @icon.x = x + 5
    @icon.y = y + 5
  end

  def move_to_square(square)
    x_offset = 320
    y_offset = 40
    x_posn = ((square % 8) * 80) + x_offset
    y_posn = ((square / 8.floor) * 80) + y_offset
    set_posn(x_posn, y_posn)
  end

  def get_other_piece_info(piece)
    if piece[0] == @color[0]
      result = "own"
    elsif piece[1] == "k"
      result = "enemy_king"
    else
      result = "enemy"
    end
  end

  def on_edge(square)
    # note: corners squares have 2 'edges', but this def only returns one edge,
    # hence corners considered as separate cases
    if square < 8
      edge = 'N'
    elsif square > 55
      edge = 'S'
    elsif square % 8 == 0
      edge = 'W'
    elsif (square + 1) % 8 == 0
      edge = 'E'
    else
      edge = 'none'
    end
  end

  def orthogonal_step(square, direction)
    corners = {0 => 'NW', 7 => 'NE', 56 => 'SW', 63 => 'SE'}
    if corners.key?(square) == true &&
      (direction == corners[square][0] || direction == corners[square][1])
      square = nil
    else
      edge = on_edge(square)
      if direction == 'N' && edge != 'N'
        square -= 8
      elsif direction == 'S' && edge != 'S'
        square += 8
      elsif direction == 'E' && edge != 'E'
        square += 1
      elsif direction == 'W' && edge != 'W'
        square -= 1
      else
        square = nil
      end
    end
    square
  end

  def diagonal_step(square, direction)
    corners = {0 => 'SE', 7 => 'SW', 56 => 'NE', 63 => 'NW'}
    if corners.key?(square) == true && direction != corners[square]
      square = nil
    else
      edge = on_edge(square)
      if direction == 'NE' && edge != 'N' && edge != 'E'
        square -= 7
      elsif direction == 'SE' && edge != 'S' && edge != 'E'
        square += 9
      elsif direction == 'SW' && edge != 'S' && edge != 'W'
        square += 7
      elsif direction == 'NW' && edge != 'N' && edge != 'W'
        square -= 9
      else
        square = nil
      end
    end
    square
  end

  def common(array_a, array_b)
    common = []
    array_a.each do |a|
      common << a if array_b.any? {|b| b == a}
    end
    common
  end
end

class Sliding_Piece < Piece
  def find_sliding_paths(posn, path_type)
    moves = []
    @disambiguate = []
    if path_type == 'orthogonal'
      directions = ['N', 'S', 'E', 'W']
    else
      directions = ['NE', 'SE', 'SW', 'NW']
    end
    directions.each do |direction|
      square, start_square = @square, @square
      loop do
        if path_type == 'orthogonal'
          new_square = orthogonal_step(square, direction)
        else
          new_square = diagonal_step(square, direction)
        end
        break if new_square == nil
        if posn[new_square] != "---"
          piece_type = get_other_piece_info(posn[new_square])
          if piece_type == "own" || piece_type == "enemy_king"
            if piece_type == "own" && posn[new_square][1] == posn[start_square][1]
              @disambiguate << new_square
            end
            break
          else
            moves << (new_square)
            break
          end
        end
        moves << (new_square)
        square = new_square
      end
    end
    # p moves # for debugging
    moves
  end
end

class Pawn < Piece
  attr_accessor :ep_square
  attr_accessor :ep_take_sq

  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_pawn.png", height: 70, width: 70)
    @icon.z = -1
    @ep_square = -1 # >= 0, == valid en-passant move square
    @ep_take_sq = -1 # >= 0, == valid en-passant capture square
  end

  def find_moves(posn, moves = [])
    @legal_moves = []
    if @checks > 1
      @legal_moves
    else
      if @color == 'white'
        directions = ['N', 'NE', 'NW']
      else
        directions = ['S', 'SE', 'SW']
      end
      new_square = @square
      new_square = orthogonal_step(new_square, directions[0])
      @legal_moves << (new_square) if posn[new_square] == '---'
      if @moved == false && @legal_moves.length > 0
        new_square = orthogonal_step(new_square, directions[0])
        @legal_moves << (new_square) if posn[new_square] == '---'
      end
      2.times do |i|
        new_square = diagonal_step(@square, directions[i + 1])
        if new_square != nil && posn[new_square] != '---'
          piece_type = get_other_piece_info(posn[new_square])
          if piece_type != "own" && piece_type != "enemy_king"
            @legal_moves << (new_square)
          end
        end
      end
      # look for en-passant opportunities (only when on 5th rank)
      opp_pawn = ''
      if @color == 'white' && @square / 8.floor == 3
        opp_pawn = 'bp'
      elsif @color == 'black' && @square / 8.floor == 4
        opp_pawn = 'wp'
      end
      if opp_pawn != ''
        # get number(s) of E & W squares (if not off-board)
        directions = ['E', 'W']
        directions.each do |e|
          new_square = orthogonal_step(@square, e)
          if new_square != nil && (moves[-1][1] - moves[-1][2]).abs == 16
            if posn[new_square][0..1] == opp_pawn
              @ep_take_sq = new_square
              if @color == 'white'
                @ep_square = new_square - 8
                @legal_moves << @ep_square
              else
                @ep_square = new_square + 8
                @legal_moves << @ep_square
              end
            end
          end
        end
      end
      if @check_blocks != []
        if @check_blocks[0] == @ep_take_sq
          @legal_moves = [@ep_square]
        else
          @legal_moves = common(@legal_moves, @check_blocks)
        end
      end
      if @pinned != {}
        pin_moves = @pinned[@name]
        @legal_moves = common(@legal_moves, pin_moves)
      end
    end
  end

end


class Rook < Sliding_Piece
  attr_reader :disambiguate

  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_rook.png", height: 70, width: 70)
    @icon.z = -1
    @disambiguate = []
  end

  def find_moves(posn, moves = [])
    if @checks > 1
      @legal_moves = []
    else
      @legal_moves = find_sliding_paths(posn, 'orthogonal')
      if @check_blocks != []
        @legal_moves = common(@legal_moves, @check_blocks)
      end
      if @pinned != {}
        pin_moves = @pinned[@name]
        @legal_moves = common(@legal_moves, pin_moves)
      end
    end
  end

end


class Knight < Piece
  attr_reader :disambiguate

  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_knight.png", height: 70, width: 70)
    @icon.z = -1
    @disambiguate = []
  end

  def find_moves(posn, moves = [])
    if @checks > 1
      @legal_moves = []
    else
      @disambiguate = []
      @legal_moves = []
      directions = ['NE', 'NW', 'EN', 'ES', 'SE', 'SW', 'WN', 'WS']
        directions.each do |direction|
          square = @square
          new_square = nil
          new_square = orthogonal_step(square, direction[0])
          new_square = orthogonal_step(new_square, direction[0]) if new_square != nil
          new_square = orthogonal_step(new_square, direction[1]) if new_square != nil
          if new_square != nil
            if posn[new_square] != "---"
              piece_type = get_other_piece_info(posn[new_square])
              if piece_type != "own" && piece_type != "enemy_king"
                @legal_moves << (new_square)
              elsif piece_type == "own" && posn[new_square][1] == 'n'
                @disambiguate << new_square
              end
            else
              @legal_moves << (new_square)
            end
          end
        end
        if @check_blocks != []
          @legal_moves = common(@legal_moves, @check_blocks)
        end
        if @pinned != {}
          pin_moves = @pinned[@name]
          @legal_moves = common(@legal_moves, pin_moves)
        end
      end
    end

end

class Bishop < Sliding_Piece
  attr_reader :disambiguate

  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_bishop.png", height: 70, width: 70)
    @icon.z = -1
    @disambiguate = []
  end

  def find_moves(posn, moves = [])
    if @checks > 1
      @legal_moves = []
    else
      @legal_moves = find_sliding_paths(posn, 'diagonal')
      if @check_blocks != []
        @legal_moves = common(@legal_moves, @check_blocks)
      end
      if @pinned != {}
        pin_moves = @pinned[@name]
        @legal_moves = common(@legal_moves, pin_moves)
      end
    end
  end

end

class Queen < Sliding_Piece
  attr_reader :disambiguate

  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_queen.png", height: 70, width: 70)
    @icon.z = -1
    @disambiguate = []
  end

  def find_moves(posn, moves = [])
    if @checks > 1
      @legal_moves = []
    else
      dis_list = []
      orthogonal_moves = find_sliding_paths(posn, 'orthogonal')
      dis_list = @disambiguate
      diagonal_moves = find_sliding_paths(posn, 'diagonal')
      dis_list += @disambiguate
      @disambiguate = dis_list
      @legal_moves = orthogonal_moves + diagonal_moves
      if @check_blocks != []
        @legal_moves = common(@legal_moves, @check_blocks)
      end
      if @pinned != {}
        pin_moves = @pinned[@name]
        @legal_moves = common(@legal_moves, pin_moves)
      end
    end
  end
end

class King < Piece
  attr_accessor :long
  attr_accessor :short

  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_king.png", height: 70, width: 70)
    @icon.z = -1
    @long = true
    @short = true
  end

  def find_moves(game_pieces, posn, moves = [])
    def castling_square(near_sq, castle_sq, game_pieces, posn)
      if @legal_moves.any? {|e| e == near_sq} && posn[castle_sq] == '---'
        @legal_moves << castle_sq if is_in_check(game_pieces, posn, castle_sq) == false
      end
      @legal_moves
    end

    if @checks < 2 # def already run before @dbl_check set true
      @legal_moves = []
      directions = [['N', 'S', 'E', 'W'], ['NE', 'SE', 'SW', 'NW']]
      2.times do |i|
        directions[i].each do |direction|
          square = @square
          new_square = nil
          if i == 0
            new_square = orthogonal_step(square, direction)
          else
            new_square = diagonal_step(square, direction)
          end
          if new_square != nil
            if posn[new_square] != "---"
              piece_type = get_other_piece_info(posn[new_square])
              if piece_type != "own" && piece_type != "enemy_king"
                @legal_moves << (new_square)
              end
            else
              @legal_moves << (new_square)
            end
          end
        end
      end
    end

    @legal_moves.each do |move|
      checks = 0
      is_check = is_in_check(game_pieces, posn, move)
      @legal_moves = @legal_moves - [move] if is_check == true
    end

    if @checks == 0 && @moved == false # castling logic ...
      if @long == true
        if @color == 'white'
          castling_square(59, 58, game_pieces, posn)
        else
          castling_square(3, 2, game_pieces, posn)
        end
      end
      if @short == true
        if @color == 'white'
          castling_square(61, 62, game_pieces, posn)
        else
          castling_square(5, 6, game_pieces, posn)
        end
      end
    end
  end

  # @legal_moves = castle(nr_sq, cl_sq, game_pieces, posn)

  def is_in_check(game_pieces, posn, move)
    checks, check_blocks, pinned = checks_n_pins(game_pieces, posn, move)
    if checks == 0
      false
    else
      true
    end
  end

  def checks_n_pins(game_pieces, posn, square = -1)
    n_of_checks = 0
    check_blocks = []
    pinned = {}
    if square == -1
      king_sq = posn.find_index("#{@color[0]}k0")
    else
      king_sq = square
    end

    if @color == 'white'
      enemy = 'b'
      pawn_dirs = ['NE', 'NW']
    else
      enemy = 'w'
      pawn_dirs = ['SE', 'SW']
    end

    if posn.any? {|e| e.include?("#{enemy}n")}
      knight = game_pieces.detect {|e| e.name == "#{enemy}n0"}
      sq_store = knight.square
      knight.square = king_sq
      knight.find_moves(posn)
      if knight.disambiguate != []
        n_of_checks = 1
        check_blocks << knight.disambiguate[0]
      end
      knight.square = sq_store
    end

    directions = ['N', 'S', 'E', 'W', 'NE', 'SE', 'SW', 'NW']

    8.times do |i|
      path = []
      square = king_sq
      pc1 = nil
      count = 0

      loop do
        if i < 4
          square = orthogonal_step(square, directions[i])
        else
          square = diagonal_step(square, directions[i])
        end
        path << square if square != nil
        break if square == nil

        if posn[square] != '---' && posn[square] != @name
          piece = posn[square]
          if (pc1 == nil && i < 4 &&
              (piece[0..1] == "#{enemy}r" || piece[0..1] == "#{enemy}q")) ||
              (pc1 == nil && i > 3 &&
              (piece[0..1] == "#{enemy}b" || piece[0..1] == "#{enemy}q" ||
              (piece[0..1] == "#{enemy}p" && count == 0 &&
              pawn_dirs.any? {|e| e == directions[i]})))
            n_of_checks += 1
            path[0..-1].each {|e| check_blocks << e}
            break
          elsif pc1 == nil && piece[0] == enemy
            break
          elsif pc1 == nil # could be pinned piece
            pc1 = piece
          elsif pc1 != nil && piece[0] != enemy
            break
          elsif i < 4 && (piece[0..1] == "#{enemy}r" || piece[0..1] == "#{enemy}q") ||
                i > 3 && (piece[0..1] == "#{enemy}b" || piece[0..1] == "#{enemy}q")
            pinned["#{pc1}"] = []
            path[0..count].each {|e| pinned["#{pc1}"] << e}
            break
          else
            break
          end
        end
        count += 1
      end
      break if n_of_checks > 1
    end

    return n_of_checks, check_blocks, pinned
  end


end
