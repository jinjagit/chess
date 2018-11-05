require 'ruby2d'
require './pieces'
require './ui'
require './position'

module Utilities
  Coords = [['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
            ['1', '2', '3', '4', '5', '6', '7', '8']]

  def self.square_origin(index)
    x_offset = 320
    y_offset = 40
    x_posn = ((index % 8) * 80) + x_offset
    y_posn = ((index / 8.floor) * 80) + y_offset
    return x_posn, y_posn
  end
end

class HighLight_Sq
  attr_accessor :image
  attr_accessor :square
  attr_accessor :color

  def initialize(square, x, y, color = [0.0, 1.0, 0.0, 0.35])
    @square = square
    @color = color
    @image = Square.new(x: x, y: y,  size: 80, color: @color,
            z: -1)
  end

  def set_origin(square)
    @image.x, @image.y = Utilities.square_origin(square)
  end
end

class Board
  attr_accessor :game_pieces
  attr_accessor :spare_pieces
  attr_accessor :highlight_squares
  attr_accessor :posn
  attr_accessor :home_square

  def initialize(posn = Position.get_posn('start'))
    @piece_codes = {'q' => Queen, 'r' => Rook, 'n' => Knight, 'b' => Bishop,
                    'p' => Pawn, 'k' => King}
    @coords = Utilities::Coords
    @coords_on = true
    @highlight_sqs = []
    @spare_pieces = []
    @game_pieces = []
    @posn = posn
    @start_square = HighLight_Sq.new(-1, 0, 0, [0.95, 0.95, 0.258, 0.35])
    @end_square = HighLight_Sq.new(-1, 0, 0, [0.95, 0.95, 0.258, 0.35])
    @home_square = HighLight_Sq.new(-1, 0, 0, [0.5, 0.5, 0.5, 0.65])
    @promo_sqs = []

    draw_board
    draw_coords
    create_spare_pieces
    create_promo_squares
    set_up_posn
  end

  def draw_coords
    file = [354, 690]
    rank = [290, 628]
    color = '#ffffff'
    if @coords_on == true
      layer = 3
    else
      layer = -1
    end
    8.times do |i|
      Text.new(@coords[0][i], x: file[0] + (i * 80), y: file[1],
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: color, z: layer)
    end
    8.times do |i|
      Text.new(@coords[1][i], x: rank[0], y: rank[1] - (i * 80),
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: color, z: layer)
    end
  end

  def start_end_squares(start_sq, end_sq)
    @start_square.image.z = 2
    @end_square.image.z = 2
    @start_square.set_origin(start_sq)
    @end_square.set_origin(end_sq)
  end

  def hide_start_end
    @start_square.image.z = -1
    @end_square.image.z = -1
  end

  def highlight_squares(list)
    list.each {|sq| (@highlight_sqs.detect {|e| e.square == sq}).image.z = 2}
  end

  def unhighlight_squares(list)
    list.each {|sq| (@highlight_sqs.detect {|e| e.square == sq}).image.z = -1}
  end

  def mouse_square(x, y)
    square = nil
    if x < 320 || y < 40 || x > 960 || y > 680
      "off_board"
    else
      square = ((((y - 40) / 80).floor) * 8) + ((x - 320) / 80.floor)
    end
  end

  def show_home_piece(piece, square)
    home_piece = @spare_pieces.detect {|e| e.name.include?(piece[0..1])}
    home_piece.move_to_square(square)
    home_piece.icon.z = 2
    @home_square.set_origin(square)
    @home_square.image.z = 2
  end

  def hide_home_piece(piece)
    home_piece = @spare_pieces.detect {|e| e.name.include?(piece[0..1])}
    home_piece.icon.z = -1
    @home_square.image.z = -1
  end

  def create_promo_squares
    4.times do
      @promo_sqs << HighLight_Sq.new(-1, 0, 0, [0.62, 0.26, 0.957, 1.0])
    end
  end

  def show_promo_pieces(square)
    promo_pcs = ['wqx', 'wrx', 'wnx', 'wbx', 'bqx', 'brx', 'bnx', 'bbx']
    promo_sq = 0
    4.times do |i|
      if square < 8
        promo_sq = square + (i * 8)
        @promo_sqs[i].set_origin(promo_sq)
        promo_pc = @spare_pieces.detect {|e| e.name == promo_pcs[i]}
      else
        promo_sq = square - (i * 8)
        @promo_sqs[i].set_origin(promo_sq)
        promo_pc = @spare_pieces.detect {|e| e.name == promo_pcs[i + 4]}
      end
      @promo_sqs[i].image.z = 9
      promo_pc.move_to_square(promo_sq)
      promo_pc.icon.z = 10
    end
  end

  def draw_board
    64.times do |i|
      if (i + (i / 8.floor)) % 2 == 0
        square_color = '#e5d4b0' # light square
      else
        square_color = '#ba8f64' # dark square
      end

      x_posn, y_posn = Utilities.square_origin(i)

      Square.new(
        x: x_posn, y: y_posn,
        size: 80,
        color: square_color,
        z: 1)

      @highlight_sqs << HighLight_Sq.new(i, x_posn, y_posn)
    end
  end

  def create_spare_pieces
    names = ['wpx', 'wrx', 'wnx', 'wbx', 'wqx', 'wkx',
             'bpx', 'brx', 'bnx', 'bbx', 'bqx', 'bkx']
    @spare_pieces = []

    names.each do |name|
      color = name[0]
      piece = @piece_codes[name[1]].new(name, color, -1)
      @spare_pieces << piece
    end
  end

  def add_piece(square)
    posn_pc = @posn[square]

    n = game_pieces.count do |piece|
      piece.class == @piece_codes[posn_pc[1]] && piece.color[0] == posn_pc[0]
    end

    name = "#{posn_pc}#{n}"
    if name[0] == "w"
      color = "white"
    else
      color = "black"
    end

    @game_pieces << @piece_codes[posn_pc[1]].new(name, color, square)
    @posn[square] = name
    x_pos, y_pos = Utilities.square_origin(square)
    @game_pieces[-1].set_posn(x_pos, y_pos)
    @game_pieces[-1].icon.z = 3
    return @game_pieces[-1]
  end

  def set_up_posn(first_run = true)
    @posn.each_with_index do |posn_pc, square|
      if posn_pc != "--"
        if first_run == true
          piece = add_piece(square)
        else # == not first run; basic set of piece instances already exists
          if @game_pieces.detect {|e| e.name.include?(posn_pc) && e.icon.z < 0}
            piece = @game_pieces.detect {|e| e.name.include?(posn_pc) && e.icon.z < 0}
            piece.moved = false # **needs more finesse when loading saved game
                                # (**see notes, at end of this file)
          else
            piece = add_piece(square)
          end
          @posn[square] = piece.name
          x_pos, y_pos = Utilities.square_origin(square)
          piece.set_posn(x_pos, y_pos)
          piece.icon.z = 3
          piece.square = square
        end
      else
        @posn[square] = "---" # just to make array look neater ;-)
      end
    end
    # **needs more finesse when loading saved game (**see notes, below)
    @game_pieces.each {|piece| piece.moved = false}

    # list_piece_instance_vars # debug list
  end

  def clear_pieces # clears all pieces (incl. spares / hidden)
    @game_pieces.each {|e| e.icon.z = -1}
    puts
    puts "game_pieces.length = #{game_pieces.length}"
    puts
  end

  def list_piece_instance_vars # for debug output
    @game_pieces.each do |e|
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

# **note: pieces loaded from saved game, or from PGN file, may need their
# instance vars set to non-default values (e.g. @ep_square).
# This could be made easier for native saved files (by saving the relevant
# instance vars with reference to the relevant pieces), but can only be
# calculated for PGN files (by stepping through the game moves, from the start)

# 'spare' pieces (12 = 1 of each class/color) will have @name ending in 'x' and
# their icons will be used as ghost pieces (on original square) when player
# attempts to move a posn_pc, and as icons on promotion menu (if pawn promoted)
