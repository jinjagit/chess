require 'ruby2d'
require './pieces'

module Board
  class HighLight_Sq
    attr_accessor :icon
    attr_accessor :square

    def initialize(square, x, y)
      @square = square
      @icon = Square.new(
              x: x, y: y,
              size: 80,
              color: [0.0, 1.0, 0.0, 0.35], # transparent green
              z: -1)
    end
  end

  def self.highlight_squares(list, highlight_sqs)
    list.each {|sq| (highlight_sqs.detect {|e| e.square == sq}).icon.z = 5}
  end

  def self.unhighlight_squares(list, highlight_sqs)
    list.each {|sq| (highlight_sqs.detect {|e| e.square == sq}).icon.z = -1}
  end

  def self.mouse_square(x, y)
    square = nil
    if x < 320 || y < 40 || x > 960 || y > 680
      "off_board"
    else
      square = ((((y - 40) / 80).floor) * 8) + ((x - 320) / 80.floor)
    end
  end

  def self.square_origin(index)
    x_offset = 320
    y_offset = 40
    x_posn = ((index % 8) * 80) + x_offset
    y_posn = ((index / 8.floor) * 80) + y_offset
    return x_posn, y_posn
  end

  def self.draw_board
    highlight_sqs = []
    64.times do |i|
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
        z: 1)

      highlight_sqs << HighLight_Sq.new(i, x_posn, y_posn)
    end
    highlight_sqs
  end

  def self.set_up_posn(all_pieces, posn, piece_codes, first_run = false)
    posn.each_with_index do |posn_pc, square|
      if posn_pc != "--"
        if first_run == true
          n = all_pieces.count do |piece|
            piece.class == piece_codes[posn_pc[1]] && piece.color[0] == posn_pc[0]
          end
          name = "#{posn_pc}#{n}"
          if name[0] == "w"
            color = "white"
          else
            color = "black"
          end
          all_pieces << piece_codes[posn_pc[1]].new(name, color, square)
          posn[square] = name
          x_pos, y_pos = square_origin(square)
          all_pieces[-1].set_posn(x_pos, y_pos)
          all_pieces[-1].icon.z = 3
        else # == not first run; basic set of piece instances already exists
          piece = all_pieces.detect {|e| e.name.include?(posn_pc) && e.icon.z < 0}
          posn[square] = piece.name
          x_pos, y_pos = square_origin(square)
          piece.set_posn(x_pos, y_pos)
          piece.icon.z = 3
          piece.square = square
        end
      else
        posn[square] = "---" # just to make array look neater ;-)
      end
    end
    # need to load state for piece.moved? for rooks, kings & pawns if loading
    # a 'real' saved game (which means this needs saving or calculating on load)
    all_pieces.each {|piece| piece.moved = false}

      # list_piece_instance_vars(all_pieces) # debug list
  end

  def self.clear_pieces(all_pieces) # clears all pieces (incl. spares / hidden)
    all_pieces.each {|e| e.icon.z = -1}
    puts "all_pieces.length = #{all_pieces.length}"
    puts
  end

  def self.list_piece_instance_vars(all_pieces) # for debug output
    all_pieces.each do |e|
      print "name: #{e.name}  color: #{e.color}  square: #{e.square}   "
      if defined? e.moved
        print "moved: #{e.moved}  "
      end
      print "icon: x: #{e.icon.x}  y: #{e.icon.y}  z: #{e.icon.z}"
      print "\n"
    end
    puts
  end

end

# 'spare' pieces (12 = 1 of each class/color) will have @name ending in 'x' and
# their icons will be used as ghost pieces (on original square) when player
# attempts to move a posn_pc, and as icons on promotion menu (if pawn promoted)
