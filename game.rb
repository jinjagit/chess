class Game
  attr_accessor :ply
  attr_reader :to_move

  def initialize
    @ply = 0
    @to_move = 'white'
  end

  def move_made
    @ply += 1
    if @ply % 2 == 0
      @to_move = 'white'
    else
      @to_move = 'black'
    end
    puts "move made: #{@to_move} to move (ply now: #{@ply})"
  end

end
