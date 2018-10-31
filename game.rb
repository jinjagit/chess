class Game
  attr_accessor :ply
  attr_reader :to_move
  attr_accessor :status
  attr_accessor :moves

  def initialize
    @ply = 0
    @to_move = 'white'
    @status = Text.new('Game in progress - move 1: White to move', x: 400,
      y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
    @moves = [] # [['piece', start_square, end_square, 'x?+?#?']]
  end

  def move_made(piece, start_square, end_square, details = '')
    @ply += 1
    if @ply % 2 == 0
      @to_move = 'white'
    else
      @to_move = 'black'
    end
    @moves << [piece, start_square, end_square, details]


    @status.remove
    to_m = @to_move.capitalize
    @status = Text.new(
      "Game in progress - move #{(@ply + 2) / 2}: #{to_m} to move",
       x: 400, y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24,
       color: '#ffffff', z: 3)
    p @moves
  end

end
