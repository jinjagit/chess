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
    @game_over = ''
    @title_w = Image.new("img/ui/title_w.png", height: 50, width: 128, z: 2)
    @title_b = Image.new("img/ui/title_b.png", height: 50, width: 128, z: 2)
    @to_move_ind = Image.new("img/ui/to_move_ind.png", height: 46, width: 15, z: 2)
    @to_move_bot = [1002, 619]
    @to_move_top = [1002, 62]
    @w_material = 39
    @b_material = 39
    @w_diff = 0
    @b_diff = 0
    @winner = ''
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
    @prog_txt = Text.new(" Game in progress ", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt1 = Text.new("    Game over!", x:1036, y: 294, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    @g_o_txt2 = Text.new("    #{@winner} wins", x:1036, y: 358, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt3 = Text.new("   by checkmate", x:1036, y: 387, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt4 = Text.new("     Draw by", x:1042, y: 358, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt5 = Text.new("    stalemate", x:1042, y: 387, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt6 = Text.new("   insufficient", x:1036, y: 375, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    @g_o_txt7 = Text.new("     material", x:1036, y: 402, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    @g_o_txt8 = Text.new("   50-move rule", x:1036, y: 387, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt9 = Text.new("    threefold", x:1041, y: 375, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    @g_o_txt10 = Text.new("    repetition", x:1036, y: 402, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    @tooltip1 = Text.new(" show coordinates", x:1036, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip2 = Text.new(" hide coordinates ", x:1036, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip3 = Text.new("    flip board", x:1036, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip4 = Text.new(" turn autoflip OFF", x:1034, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip5 = Text.new(" turn autoflip ON", x:1034, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @info_temp = []
    @flip_icon = Image.new("img/ui/flip_icon.png", height: 30, width: 33,
                            z: 1, x: 1020, y: 245, color: '#888888')
    @autoflip_off = Image.new("img/ui/autoflip_off.png", height: 30, width: 33,
                            z: 1, x: 1057, y: 245, color: '#888888')
    @autoflip_on = Image.new("img/ui/autoflip_on.png", height: 30, width: 33,
                            z: -1, x: 1057, y: 245, color: '#888888')
    @coords_icon = Image.new("img/ui/coords_icon.png", height: 30, width: 30,
                            z: 1, x: 1095, y: 245, color: '#888888')
    @test = Rectangle.new(height: 30, width: 195, z: 3, color: '#888888',
                          x: 1030, y: 402)
    @claim_txt = Text.new("claim draw", x:1076, y: 407, z: 4, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
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

  def flip_if_needed(posn, board, game)
    if @autoflip == true && ((@ply % 2 == 1) && @flipped == false) ||
                    ((@ply % 2 == 0)  && @flipped == true)
      flip_board(posn, board, game)
    end
  end

  def flip_board(posn, board, game)
    if board.flipped == false
      board.posn = posn.reverse
      board.flipped = true
      game.flipped = true
      @flipped = true
      update_move_ind
      board.clear_pieces
      board.set_up_posn(first_run = false)
      board.flip_start_end if board.start_end != []
    else
      board.posn = posn
      board.flipped = false
      game.flipped = false
      @flipped = false
      update_move_ind
      board.clear_pieces
      board.set_up_posn(first_run = false)
      board.flip_start_end if board.start_end != []
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
  end

  def move_update(posn, board, game)
    @ply = game.ply
    @checks = game.checks
    update_move_ind
    if game.w_material != @w_material || game.b_material != @b_material
      @w_material, @b_material = game.w_material, game.b_material
      material_diff
      @w_material_text.remove
      @b_material_text.remove
      @w_material_text = Text.new("#{@w_material} (#{@w_diff})", x:1160, y: 628,
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
      @b_material_text = Text.new("#{@b_material} (#{@b_diff})", x:1160, y: 71,
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
    end
    flip_if_needed(posn, board, game) if @autoflip == true
    if game.game_over != ''
      @game_over = game.game_over
      switch_info
    end
  end

  def game_over
    if @game_over == 'checkmate!'
      @to_move_ind.z = -1
      if @ply == 0
        @winner = 'Black'
      else
        @winner = 'White'
      end
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
      @g_o_txt2.x, @g_o_txt2.y, @g_o_txt2.z = 1036, 358, 2
      @g_o_txt3.x, @g_o_txt3.y, @g_o_txt3.z = 1036, 387, 2
    elsif @game_over == 'stalemate!'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1042, 358, 2
      @g_o_txt5.z = 2
    elsif @game_over == 'insufficient!'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 294, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1041, 348, 2
      @g_o_txt6.z = 2
      @g_o_txt7.z = 2
    elsif @game_over == '50-move rule!'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1042, 358, 2
      @g_o_txt8.z = 2
    elsif @game_over == '3-fold repetition!'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 294, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1041, 348, 2
      @g_o_txt9.z = 2
      @g_o_txt10.z = 2
    end
  end

  def event(x, y, event_type, posn = nil, board = nil, game = nil)
    if x > 1020 && x < 1125 && y > 245 && y < 275 # button icons
      info_off if @hover == ''

      if x > 1020 && x < 1055 && y > 245 && y < 275 # flip button
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'flip'
          hover_on('flip') if @hover != 'flip'
        else # event_type == 'click' (flip board)
          flip_board(posn, board, game)
          hover_on('flip')
        end
      elsif x > 1055 && x < 1093 && y > 245 && y < 275 # autoflip button
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'autoflip'
          hover_on('autoflip') if @hover != 'autoflip'
        else # event_type == 'click' (auto-flip board)
          if @autoflip == true
            hover_off
            @autoflip = false
          else
            hover_off
            @autoflip = true
            flip_if_needed(posn, board, game)
          end
          hover_on('autoflip')
        end
      elsif x > 1093 && x < 1125 && y > 245 && y < 275 # coords button
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'coords'
          hover_on('coords') if @hover != 'coords'
        else # event_type == 'click' (toggle coords display)
          if board.coords_on == true
            board.hide_coords
            board.coords_on = false
            hover_off
            @coords_on = false
          else
            board.show_coords
            board.coords_on = true
            hover_off
            @coords_on = true
          end
          hover_on('coords')
        end
      end
    else # not in button icons area
      hover_off
      info_on
      @hover = ''
    end
  end

  def hover_on(element)
    if element == 'coords'
      @coords_icon.color = '#ffffff'
      if @coords_on == false
        @tooltip1.z = 1
      else
        @tooltip2.z = 1
      end
      @hover = 'coords'
    elsif element == 'flip'
      @tooltip3.z = 1
      @flip_icon.color = '#ffffff'
      @hover = 'flip'
    elsif element == 'autoflip'
      if @autoflip == true
        @tooltip4.z = 1
        @autoflip_on.z = 1
        @autoflip_off.z = -1
        @autoflip_on.color = '#ffffff'
      else
        @tooltip5.z = 1
        @autoflip_off.z = 1
        @autoflip_on.z = -1
        @autoflip_off.color = '#ffffff'
      end
      @hover = 'autoflip'
    end
  end

  def hover_off
    if @hover == 'coords'
      @coords_icon.color = '#888888'
      if @coords_on == false
        @tooltip1.z = -1
      else
        @tooltip2.z = -1
      end
    elsif @hover == 'flip'
      @flip_icon.color = '#888888'
      @tooltip3.z = -1
    elsif @hover == 'autoflip'
      if @autoflip == true
        @autoflip_on.color = '#888888'
        @tooltip4.z = -1
      else
        @autoflip_off.color = '#888888'
        @tooltip5.z = -1
      end
    end
  end

  def info_on
      if @game_over == ''
        @prog_txt.z = 1
      else
        game_over
      end
  end

  def info_off
      if @game_over == ''
        @prog_txt.z = -1
      else
        hide_game_over
      end
  end

  def switch_info
    if @game_over == ''
      @prog_txt.z = 1
      hide_game_over
    else
      @prog_txt.z = -1
      game_over
    end
  end

  def hide_game_over
    @g_o_txt1.z = -1
    @g_o_txt2.z = -1
    @g_o_txt3.z = -1
    @g_o_txt4.z = -1
    @g_o_txt5.z = -1
    @g_o_txt6.z = -1
    @g_o_txt7.z = -1
    @g_o_txt8.z = -1
    @g_o_txt9.z = -1
    @g_o_txt10.z = -1
  end

end
