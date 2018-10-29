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
    if direction == 'N' && (square - 8) >= 0
      square - 8
    elsif direction == 'S' && (square + 8) < 64
      square + 8
    elsif direction == 'E' && (square + 1) % 8 != 0
      square + 1
    elsif direction == 'W' &&  (square - 1) % 8 != 7
      square - 1
    else
      square
    end
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

  def find_moves
    @legal_moves = []
    directions = ['N', 'S', 'E', 'W']
    directions.each do |direction|
      square = @square
      loop do
        new_square = orthogonal_step(square, direction)
        if new_square == square
          break
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
