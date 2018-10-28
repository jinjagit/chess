class Piece
  attr_reader :color
  attr_reader :z

  def initialize(name, color)
    @name = name
    @color = color
    @x = 0
    @y = 0
    @z = -1
  end

  def set_posn(x, y)
    @x = x
    @y = y
  end

  def set_layer(z)
    @z = z
  end
end

class Pawn < Piece
  def initialize(name, color)
    super
  end
end

class Knight < Piece
  def initialize(name, color)
    super
  end
end
