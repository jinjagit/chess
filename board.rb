module Board

  def self.square_origin(index)
    x_offset = 320
    y_offset = 40

    x_posn = ((index % 8) * 80) + x_offset
    y_posn = ((index / 8.floor) * 80) + y_offset

    return x_posn, y_posn
  end

  def self.draw_board
    i = 0

    64.times do
      if (i + (i / 8.floor)) % 2 == 0
        square_color = '#e5d4b0' # light square
      else
        square_color = '#ba8f64' # dark square
      end

      x_posn, y_posn = square_origin(i)

      Square.new(
        x: x_posn, y: y_posn,
        size: 80,
        color: square_color,
        z: 5
      )

      i += 1
    end
  end

end
