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

  def beyond_edge(square, direction)
    if direction == 'N' && (square - 8) >= 0
      false
    elsif direction == 'S' && (square + 8) < 64
      false
    elsif direction == 'E' && (square + 1) % 8 != 0
      false
    elsif direction == 'W' &&  (square - 1) % 8 != 7
      false
    else
      true
    end
  end

  def on_edge(square)
    if square < 8
      edge = 'N'
    elsif square > 55
      edge = 'S'
    elsif square % 8 == 0
      edge = 'W'
    elsif (square + 1) % 8 ==0
      edge = 'E'
    else
      edge = 'none'
    end
  end

  def orthogonal_step(square, direction)
    off_board = beyond_edge(square, direction)
    edge = on_edge(square)
    if direction == 'N' && edge != 'N'
      square - 8
    elsif direction == 'S' && edge != 'S'
      square + 8
    elsif direction == 'E' && edge != 'E'
      square + 1
    elsif direction == 'W' && edge != 'W'
      square - 1
    else
      square = nil
    end
  end

  def diagonal_step(square, direction)
    quadrants = ['W', 'N', 'N', 'N', 'N', 'N', 'N', 'N',
                 'W', 'W', 'N', 'N', 'N', 'N', 'N', 'E',
                 'W', 'W', 'W', 'N', 'N', 'N', 'E', 'E',
                 'W', 'W', 'W', 'W', 'N', 'E', 'E', 'E',
                 'W', 'W', 'W', 'S', 'E', 'E', 'E', 'E',
                 'W', 'W', 'S', 'S', 'S', 'E', 'E', 'E',
                 'W', 'S', 'S', 'S', 'S', 'S', 'E', 'E',
                 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'E']
    directions = ['NE', 'SE', 'SW', 'NW']
    quadrant = quadrants[square]
    edges = {}
    directions.each do |e|
      if e.include? quadrant
        edges[e] = quadrant
        directions -= [e]
      end
    end
    char = 0
    char = 1 if directions[0][0] == directions[1][0]
    edges[directions[0]] = directions[0][char]
    edges[directions[1]] = directions[1][char]

    p edges
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
    @legal_moves = []
    directions = ['N', 'S', 'E', 'W']
    directions.each do |direction|
      square = @square
      loop do
        new_square = orthogonal_step(square, direction)
        if new_square == nil
          break
        end
        if posn[new_square] != "---"
          piece_type = get_other_piece_info(posn[new_square])
          if piece_type == "own" || piece_type == "enemy_king"
            break
          else
            @legal_moves << (new_square)
            break
          end
        end
        @legal_moves << (new_square)
        square = new_square
      end
    end
    p @legal_moves
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
    square = @square
    direction = 'NE'
    diagonal_step(square, direction)
  end
end

class Queen < Piece
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_queen.png", height: 70, width: 70)
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
