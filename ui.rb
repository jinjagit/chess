class UI
  attr_accessor :coords
  attr_accessor :flipped

  def initialize
    @hover = ''
    @coords = true
    @coords_on = true
    @flipped = false
    @autoflip = false
    @ply = 0
    @checks = 0
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
    @w_material_text = Text.new("39 (0)", x:1160, y: 628, z: 2, size: 24,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @b_material_text = Text.new("39 (0)", x:1160, y: 71, z: 2, size: 24,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @material_top = [1160, 71]
    @material_bot = [1160, 628]
    @info_box = Image.new("img/ui/info_box.png", height: 160, width: 210, z: 1,
                          x: 1022, y: 280)
    @info_text1 = Text.new(" Game in progress ", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @info_text2 = Text.new('', z: -1)
    @info_text3 = Text.new('', z: -1)
    @info_text4 = Text.new('', z: -1)
    @info_text5 = Text.new('', z: -1)
    @basic_info = [@info_text1, @info_text2, @info_text3, @info_text4, @info_text5]
    @info_text6 = Text.new('', z: -1)
    @info_temp = []
    @flip_icon = Image.new("img/ui/flip_icon.png", height: 30, width: 33,
                            z: 1, x: 1020, y: 245, color: '#888888')
    @autoflip_off = Image.new("img/ui/autoflip_off.png", height: 30, width: 33,
                            z: 1, x: 1057, y: 245, color: '#888888')
    @autoflip_on = Image.new("img/ui/autoflip_on.png", height: 30, width: 33,
                            z: -1, x: 1057, y: 245, color: '#888888')
    @coords_icon = Image.new("img/ui/coords_icon.png", height: 30, width: 30,
                            z: 1, x: 1095, y: 245, color: '#888888')
  end

  def place_defaults
    if @flipped == false
      @title_w.x, @title_w.y = @title_bot[0], @title_bot[1]
      @title_b.x, @title_b.y = @title_top[0], @title_top[1]
      @w_material_text.x, @w_material_text.y = @material_bot[0], @material_bot[1]
      @b_material_text.x, @b_material_text.y = @material_top[0], @material_top[1]
      update_move_ind
    else
      @title_w.x, @title_w.y = @title_top[0], @title_top[1]
      @title_b.x, @title_b.y = @title_bot[0], @title_bot[1]
      @w_material_text.x, @w_material_text.y = @material_top[0], @material_top[1]
      @b_material_text.x, @b_material_text.y = @material_bot[0], @material_bot[1]
      update_move_ind
    end
  end

  def material_diff
    @w_diff = @w_material - @b_material
    @w_diff = '+' + @w_diff.to_s if @w_diff > 0
    @b_diff = @b_material - @w_material
    @b_diff = '+' + @b_diff.to_s if @b_diff > 0
  end

  def update_move_ind
    if @ply % 2 == 0
      if flipped == false
        @to_move_ind.x, @to_move_ind.y = @to_move_bot[0], @to_move_bot[1]
      else
        @to_move_ind.x, @to_move_ind.y = @to_move_top[0], @to_move_top[1]
      end
    else
      if flipped == false
        @to_move_ind.x, @to_move_ind.y = @to_move_top[0], @to_move_top[1]
      else
        @to_move_ind.x, @to_move_ind.y = @to_move_bot[0], @to_move_bot[1]
      end
    end
  end

  def move_update(data)
    @ply = data[0]
    @checks = data[4]
    update_move_ind
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

    game_over(data) if data[3] != ''
  end

  def game_over(data)
    if data[3] == 'checkmate!'
      @to_move_ind.z = -1
      if data[0] % 2 == 0
        winner = 'Black'
      else
        winner = 'White'
      end
      @info_text1.remove
      @info_text2 = Text.new("    Game over!    ", x:1036, y: 306, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text4 = Text.new("    #{winner} wins", x:1036, y: 358, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text5 = Text.new("   by checkmate", x:1036, y: 387, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    elsif data[3] == 'stalemate!'
      @info_text1.remove
      @info_text2 = Text.new("    Game over!", x:1036, y: 306, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text4 = Text.new("     Draw by", x:1042, y: 358, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text5 = Text.new("    stalemate", x:1042, y: 387, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    elsif data[3] == 'insufficient!'
      @info_text1.remove
      @info_text1 = Text.new("    Game over!", x:1036, y: 294, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
      @info_text3 = Text.new("     Draw by", x:1041, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
      @info_text4 = Text.new("   insufficient", x:1036, y: 375, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
      @info_text5 = Text.new("     material", x:1036, y: 402, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    elsif data[3] == '50-move rule!'
      @info_text1.remove
      @info_text2 = Text.new("    Game over!", x:1036, y: 306, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text4 = Text.new("     Draw by", x:1042, y: 358, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      @info_text5 = Text.new("   50-move rule", x:1036, y: 387, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    elsif data[3] == '3-fold repetition!'
      @info_text1.remove
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

  def event(x, y, event_type, posn = nil, board = nil, game = nil)
    if x > 1020 && x < 1055 && y > 245 && y < 275 # flip button
      if event_type == 'hover'
        @flip_icon.color = '#ffffff'
        @hover = 'flip'
        show_hover_info
      else # event_type == 'click' (flip board)
        if board.flipped == false
          board.posn = posn.reverse
          board.flipped = true
          game.flipped = true
          @flipped = true
          update_move_ind
          board.clear_pieces
          board.set_up_posn(first_run = false)
          board.flip_start_end if @ply > 0
        else
          board.posn = posn
          board.flipped = false
          game.flipped = false
          @flipped = false
          update_move_ind
          board.clear_pieces
          board.set_up_posn(first_run = false)
          board.flip_start_end if @ply > 0
        end
        if @checks > 0
          red_sq = board.mouse_square(game.red_square.image.x, game.red_square.image.y)
          red_sq = 63 - red_sq if @flipped == false
          game.place_red_sq(red_sq)
        end
        if board.promote != []
          board.promote[1] = 63 - board.promote[1] if @flipped == false
          board.show_promo_pieces
        end
        place_defaults
        show_hover_info
      end
    elsif x > 1055 && x < 1093 && y > 245 && y < 275 # autoflip button
      @hover = 'autoflip'
      if event_type == 'hover'
        if @autoflip == false
          @autoflip_off.color = '#ffffff'
        else
          @autoflip_on.color = '#ffffff'
        end
        show_hover_info
      else # event_type == 'click' (auto-flip board)
        if @autoflip == true
          @autoflip = false
          @autoflip_off.z = 1
          @autoflip_on.z = -1
        else
          @autoflip = true
          @autoflip_on.z = 1
          @autoflip_off.z = -1
        end
        show_hover_info
      end
    elsif x > 1093 && x < 1125 && y > 245 && y < 275 # coords button
      if event_type == 'hover'
        @coords_icon.color = '#ffffff'
        @hover = 'coords'
        show_hover_info
      else # event_type == 'click' (toggle coords display)
        if board.coords_on == true
          board.hide_coords
          board.coords_on = false
          @coords_on = false
        else
          board.show_coords
          board.coords_on = true
          @coords_on = true
        end
        show_hover_info
      end
    elsif @hover != '' # unhover icon if in hover state
      @coords_icon.color = '#888888'
      @flip_icon.color = '#888888'
      if @autoflip == false
        @autoflip_off.color = '#888888'
      else
        @autoflip_on.color = '#888888'
      end
      hide_hover_info
      @hover = ''
    end
  end

  def show_hover_info
    @basic_info.each {|e| e.z = -1}
    if @hover == 'coords'
      @info_text6.remove
      if @coords_on == false
        @info_text6 = Text.new(" show coordinates", x:1036, y: 348, z: 2, size: 20,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      else
        @info_text6 = Text.new(" hide coordinates ", x:1036, y: 348, z: 2, size: 20,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      end
    elsif @hover == 'flip'
      @info_text6.remove
      @info_text6 = Text.new("    flip board", x:1036, y: 348, z: 2, size: 20,
                              font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    elsif @hover == 'autoflip'
      if @autoflip == true
        @info_text6.remove
        @info_text6 = Text.new(" turn autoflip OFF", x:1034, y: 348, z: 2, size: 20,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      else
        @info_text6.remove
        @info_text6 = Text.new(" turn autoflip ON", x:1034, y: 348, z: 2, size: 20,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
      end
    end
  end

  def hide_hover_info
    @info_text6.z = -1
    @basic_info.each {|e| e.z = 2}
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
