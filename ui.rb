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
    @w_material = 37
    @b_material = 36
    @w_diff = 0
    @b_diff = 0
    @title_top = [1020, 60]
    @title_bot = [1020, 617]
    @w_material_text = Text.new("37 (=)", x:1160, y: 628,
    font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
    @b_material_text = Text.new("37 (=)", x:1160, y: 71,
    font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
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
    @w_diff, @b_diff = '=', '=' if @w_material - @b_material == 0
  end

  def move_update(data)
    if data[0] % 2 == 0
      @to_move_ind.x, @to_move_ind.y = @to_move_bot[0], @to_move_bot[1]
    else
      @to_move_ind.x, @to_move_ind.y = @to_move_top[0], @to_move_top[1]
    end
  end

end


# Text.new("#{@b_material} (#{@b_diff})", x:1160, y: 71,
# font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
