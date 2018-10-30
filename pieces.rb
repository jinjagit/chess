class Piece
  attr_reader :color
  attr_reader :name
  attr_accessor :icon
  attr_accessor :square
  attr_accessor :legal_moves

  def initialize(name, color, square)
    @name = name
    @color = color
    @square = square
    @legal_moves = []
  end

  def set_posn(x, y)
    @icon.x = x + 5
    @icon.y = y + 5
  end

  def set_layer(z)
    @icon.z = z
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
    edge = 'none'
    edge = 'N' if square < 8
    edge = 'S' if square > 55
    edge = 'W' if square % 8 == 0
    edge = 'E' if (square + 1) % 8 == 0
    edge
  end

  def orthogonal_step(square, direction)
    corners = {0 => 'NW', 7 => 'NE', 56 => 'SW', 63 => 'SE'}
    if corners.key?(square) == true && (direction == corners[square][0] || direction == corners[square][1])
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

  def find_sliding_paths(posn, path_type)
    moves = []
    if path_type == 'orthogonal'
      directions = ['N', 'S', 'E', 'W']
    else
      directions = ['NE', 'SE', 'SW', 'NW']
    end
    directions.each do |direction|
      square = @square
      loop do
        if path_type == 'orthogonal'
          new_square = orthogonal_step(square, direction)
        else
          new_square = diagonal_step(square, direction)
        end
        if new_square == nil
          break
        end
        if posn[new_square] != "---"
          piece_type = get_other_piece_info(posn[new_square])
          if piece_type == "own" || piece_type == "enemy_king"
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
    p moves
    moves
  end

end


class Pawn < Piece
  attr_accessor :moved
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_pawn.png", height: 70, width: 70)
    @moved = false
  end
end


class Rook < Piece
  attr_accessor :moved
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_rook.png", height: 70, width: 70)
    @moved = false
  end

  def find_moves(posn)
    @legal_moves = find_sliding_paths(posn, 'orthogonal')
  end

end


class Knight < Piece
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_knight.png", height: 70, width: 70)
  end
end

class Bishop < Piece
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_bishop.png", height: 70, width: 70)
  end

  def find_moves(posn)
    @legal_moves = find_sliding_paths(posn, 'diagonal')
  end

end

class Queen < Piece
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_queen.png", height: 70, width: 70)
  end

  def find_moves(posn)
    orthogonal_moves = find_sliding_paths(posn, 'orthogonal')
    diagonal_moves = find_sliding_paths(posn, 'diagonal')
    @legal_moves = orthogonal_moves + diagonal_moves
    puts "queen: #{@legal_moves}"
  end
end

class King < Piece
  attr_accessor :moved
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_king.png", height: 70, width: 70)
    @moved = false
  end
end
