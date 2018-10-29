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

  def orthogonal_step(square, direction)
    possible = false
    if direction == 'N' && (square - 8) >= 0
      possible = true
    elsif direction == 'S' && (square + 8) < 64
      possible = true
    elsif direction = 'E' && (square % 8) != 0
      possible = true
    elsif (square + 1) % 8 != 0
      possible = true
    end
  end
end


class Pawn < Piece
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_pawn.png", height: 70, width: 70)
  end
end

class Rook < Piece
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_rook.png", height: 70, width: 70)
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
end

class Queen < Piece
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_queen.png", height: 70, width: 70)
  end
end

class King < Piece
  def initialize(name, color, square)
    super
    @icon = Image.new("img/#{@color[0]}_king.png", height: 70, width: 70)
  end
end
