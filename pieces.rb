class Piece
  attr_reader :color
  attr_reader :z
  attr_reader :name
  attr_accessor :icon

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
    @icon.x = @x + 5
    @icon.y = @y + 5
  end

  def set_layer(z)
    @z = z
    @icon.z = @z
  end
end


class Pawn < Piece
  def initialize(name, color)
    super
    @icon = Image.new("img/#{@color[0]}_pawn.png", height: 70, width: 70)
  end
end

class Rook < Piece
  def initialize(name, color)
    super
    @icon = Image.new("img/#{@color[0]}_rook.png", height: 70, width: 70)
  end
end

class Knight < Piece
  def initialize(name, color)
    super
    @icon = Image.new("img/#{@color[0]}_knight.png", height: 70, width: 70)
  end
end

class Bishop < Piece
  def initialize(name, color)
    super
    @icon = Image.new("img/#{@color[0]}_bishop.png", height: 70, width: 70)
  end
end

class Queen < Piece
  def initialize(name, color)
    super
    @icon = Image.new("img/#{@color[0]}_queen.png", height: 70, width: 70)
  end
end

class King < Piece
  def initialize(name, color)
    super
    @icon = Image.new("img/#{@color[0]}_king.png", height: 70, width: 70)
  end
end
