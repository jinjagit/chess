class Game
  attr_accessor :ply
  attr_reader :to_move
  attr_accessor :status

  def initialize
    @ply = 0
    @to_move = 'white'
    @status = Text.new('Game in progress - move 1: White to move', x: 400,
      y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
  end

  def move_made
    @ply += 1
    if @ply % 2 == 0
      @to_move = 'white'
    else
      @to_move = 'black'
    end
    @status.remove
    @status = Text.new("Game in progress - move #{(@ply + 2) / 2}: #{@to_move.capitalize} to move", x: 400,
      y: 8, font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)
  end

end

#'Game in progress - Move 1: White to move'
