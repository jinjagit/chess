require 'ruby2d'
require './pieces'
require './ui'


module Board
  Piece_Codes = {'p' => Pawn, 'r' => Rook, 'n' => Knight, 'b' => Bishop,
                'q' => Queen, 'k' => King}
  Coords = [['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
            ['1', '2', '3', '4', '5', '6', '7', '8']]

  class HighLight_Sq
    attr_accessor :icon
    attr_accessor :square
    attr_accessor :color

    def initialize(square, x, y, color = [0.0, 1.0, 0.0, 0.35])
      @square = square
      @color = color
      @icon = Square.new(x: x, y: y,  size: 80, color: @color,
              z: -1)
    end
  end

  def self.draw_coords(coords)
    file = [354, 690]
    rank = [290, 628]
    color = '#ffffff'
    if coords == true
      layer = 3
    else
      layer = -1
    end
    8.times do |i|
      Text.new(Coords[0][i], x: file[0] + (i * 80), y: file[1],
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: color, z: layer)
    end
    8.times do |i|
      Text.new(Coords[1][i], x: rank[0], y: rank[1] - (i * 80),
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: color, z: layer)
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

  def self.draw_board(coords = true)
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
    draw_coords(coords)
    highlight_sqs
  end

  def self.create_spare_pieces
    names = ['wpx', 'wrx', 'wnx', 'wbx', 'wqx', 'wkx',
             'bpx', 'brx', 'bnx', 'bbx', 'bqx', 'bkx']
    spare_pieces = []

    names.each do |name|
      color = name[0]
      piece = Piece_Codes[name[1]].new(name, color, -1)
      spare_pieces << piece
    end

    spare_pieces
  end

  def self.add_piece(game_pieces, posn, square)
    posn_pc = posn[square]

    n = game_pieces.count do |piece|
      piece.class == Piece_Codes[posn_pc[1]] && piece.color[0] == posn_pc[0]
    end

    name = "#{posn_pc}#{n}"
    if name[0] == "w"
      color = "white"
    else
      color = "black"
    end

    game_pieces << Piece_Codes[posn_pc[1]].new(name, color, square)
    posn[square] = name
    x_pos, y_pos = square_origin(square)
    game_pieces[-1].set_posn(x_pos, y_pos)
    game_pieces[-1].icon.z = 3
    return game_pieces[-1]
  end

  def self.set_up_posn(game_pieces, posn, first_run = false)
    posn.each_with_index do |posn_pc, square|
      if posn_pc != "--"
        if first_run == true
          piece = add_piece(game_pieces, posn, square)
        else # == not first run; basic set of piece instances already exists
          if game_pieces.detect {|e| e.name.include?(posn_pc) && e.icon.z < 0}
            piece = game_pieces.detect {|e| e.name.include?(posn_pc) && e.icon.z < 0}
            piece.moved = false # **needs more finesse when loading saved game
                                # (**see notes, at end of this file)
          else
            piece = add_piece(game_pieces, posn, square)
          end
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
    # **needs more finesse when loading saved game (**see notes, below)
    game_pieces.each {|piece| piece.moved = false}
    game_pieces

      # list_piece_instance_vars(game_pieces) # debug list
  end

  def self.clear_pieces(game_pieces) # clears all pieces (incl. spares / hidden)
    game_pieces.each {|e| e.icon.z = -1}
    puts
    puts "game_pieces.length = #{game_pieces.length}"
    puts
    game_pieces
  end

  def self.list_piece_instance_vars(game_pieces) # for debug output
    game_pieces.each do |e|
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
