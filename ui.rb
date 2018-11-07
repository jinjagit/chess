class UI
  attr_accessor :coords
  attr_accessor :flipped

  def initialize
    @coords = true
    @flipped = false
    @title_w = Image.new("img/ui/title_w.png", height: 50, width: 128, z: 2)
    @title_b = Image.new("img/ui/title_b.png", height: 50, width: 128, z: 2)
    @to_move_ind = Image.new("img/ui/to_move_ind.png", height: 46, width: 15, z: 2)
    @w_material = '37 (=)'
    @b_material = '37 (=)'
  end

  def place_defaults
    @title_w.x = 1020
    @title_w.y = 617

    @title_b.x = 1020
    @title_b.y = 60

    Text.new(@w_material, x:1160, y: 628,
    font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
    Text.new(@b_material, x:1160, y: 71,
    font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)

    @to_move_ind.x = 1002
    @to_move_ind.y = 619
  end
end
