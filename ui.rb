class UI
  attr_accessor :coords
  attr_accessor :flipped

  def initialize
    @coords = true
    @flipped = false
    @title_w = Image.new("img/ui/title_w.png", height: 50, width: 128, z: 2)
    @title_b = Image.new("img/ui/title_b.png", height: 50, width: 128, z: 2)
    @to_move_ind = Image.new("img/ui/to_move_ind.png", height: 46, width: 15, z: 2)
    @to_move_bot = [1002, 619]
    @to_move_top = [1002, 62]
    @w_material = 39
    @b_material = 39
    @w_diff = 0
    @b_diff = 0
    @title_top = [1020, 60]
    @title_bot = [1020, 617]
    @w_material_text = Text.new("37 (0)", x:1160, y: 628,
    font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
    @b_material_text = Text.new("37 (0)", x:1160, y: 71,
    font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
    @info_box = Image.new("img/ui/info_box.png", height: 160, width: 210, z: 2,
                          x: 1022, y: 280)
    @info_text1 = Text.new(" Game in progress ", x:1036, y: 348, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
  end

  def place_defaults
    @title_w.x, @title_w.y = @title_bot[0], @title_bot[1]
    @title_b.x, @title_b.y = @title_top[0], @title_top[1]

    @to_move_ind.x, @to_move_ind.y = @to_move_bot[0], @to_move_bot[1]
  end

  def material_diff
    @w_diff = @w_material - @b_material
    @w_diff = '+' + @w_diff.to_s if @w_diff > 0
    @b_diff = @b_material - @w_material
    @b_diff = '+' + @b_diff.to_s if @b_diff > 0
  end

  def move_update(data)
    if data[0] % 2 == 0
      @to_move_ind.x, @to_move_ind.y = @to_move_bot[0], @to_move_bot[1]
    else
      @to_move_ind.x, @to_move_ind.y = @to_move_top[0], @to_move_top[1]
    end

    if data[1] != @w_material || data[2] != @b_material
      @w_material, @b_material = data[1], data[2]
      material_diff
      @w_material_text.remove
      @b_material_text.remove
      @w_material_text = Text.new("#{@w_material} (#{@w_diff})", x:1160, y: 628,
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
      @b_material_text = Text.new("#{@b_material} (#{@b_diff})", x:1160, y: 71,
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
    end

    update_info(data) if data[3] != ''

  end

  def update_info(data)
    @info_text1.remove

    if data[3] == 'checkmate!'
      if data[0] % 2 == 0
        winner = 'Black'
      else
        winner = 'White'
      end
      @info_text2 = Text.new("    Game over!    ", x:1036, y: 306, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text4 = Text.new("    #{winner} wins", x:1036, y: 358, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text5 = Text.new("   by checkmate", x:1036, y: 387, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    elsif data[3] == 'stalemate!'
      @info_text2 = Text.new("    Game over!", x:1036, y: 306, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text4 = Text.new("     Draw by", x:1042, y: 358, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text5 = Text.new("    stalemate", x:1042, y: 387, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    elsif data[3] == 'insufficient!'
      @info_text1 = Text.new("    Game over!", x:1036, y: 294, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
      @info_text3 = Text.new("     Draw by", x:1041, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
      @info_text4 = Text.new("   insufficient", x:1036, y: 375, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
      @info_text5 = Text.new("     material", x:1036, y: 402, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    elsif data[3] == '50-move rule!'
      @info_text2 = Text.new("    Game over!", x:1036, y: 306, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text4 = Text.new("     Draw by", x:1042, y: 358, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text5 = Text.new("   50-move rule", x:1036, y: 387, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    elsif data[3] == '3-fold repetition!'
      @info_text1 = Text.new("    Game over!", x:1036, y: 294, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
      @info_text3 = Text.new("     Draw by", x:1041, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
      @info_text4 = Text.new("    threefold", x:1041, y: 375, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
      @info_text5 = Text.new("    repetition", x:1036, y: 402, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    end
  end
end


# Text.new("#{@b_material} (#{@b_diff})", x:1160, y: 71,
# font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)

=begin

@status = Text.new(
  "   Game over! #{to_m} wins by checkmate", x: 400, y: 8,
  font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 3)

@info_text1 = Text.new("xGame in progressx", x:1036, y: 294, z: 2, size: 20,
                      font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
@info_text2 = Text.new("xGame in progressx", x:1036, y: 321, z: 2, size: 20,
                      font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
@info_text3 = Text.new("xGame in progressx", x:1036, y: 348, z: 2, size: 20,
                      font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
@info_text4 = Text.new("xGame in progressx", x:1036, y: 375, z: 2, size: 20,
                      font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
@info_text5 = Text.new("xGame in progressx", x:1036, y: 402, z: 2, size: 20,
                      font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )

=end
