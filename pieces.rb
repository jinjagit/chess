class Piece
  def initialize(name)
    @name = name
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
  def initialize(name)
    super
  end
end

a = Pawn.new('wp0')
puts a.inspect

a.set_posn(100,200)
a.set_layer(3)
puts a.inspect
