class UI
  attr_accessor :coords
  attr_accessor :flipped
  attr_accessor :legal_sqs

  def initialize
    @hover = ''
    @coords = true
    @coords_on = true
    @flipped = false
    @autoflip = false
    @legal_sqs = true
    @sound = true
    @draw_offer = false
    @claim = ''
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
    @g_o_txt2a = Text.new("    White wins", x:1036, y: 358, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt2b = Text.new("    Black wins", x:1036, y: 358, z: -1, size: 20,
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
    @g_o_txt11 = Text.new("    agreement", x:1042, y: 387, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip1 = Text.new("  coordinates ON", x:1033, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip2 = Text.new("  coordinates OFF", x:1033, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip3 = Text.new("    flip board", x:1036, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip4 = Text.new("   autoflip OFF", x:1037, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip5 = Text.new("   autoflip ON", x:1037, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip6 = Text.new(" legal squares ON", x:1033, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip7 = Text.new(" legal squares OFF", x:1033, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip8 = Text.new("     new game", x:1036, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip9 = Text.new("    offer draw", x:1036, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip10 = Text.new("      resign", x:1036, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip11 = Text.new(" save / load game", x:1036, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip12 = Text.new("     sound OFF", x:1032, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip13 = Text.new("     sound ON", x:1032, y: 348, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @info_temp = []
    @flip_icon = Image.new("img/ui/flip_icon.png", height: 30, width: 33,
                            z: 1, x: 1020, y: 245, color: '#888888')
    @autoflip_off = Image.new("img/ui/autoflip_off.png", height: 30, width: 33,
                            z: 1, x: 1057, y: 245, color: '#888888')
    @autoflip_on = Image.new("img/ui/autoflip_on.png", height: 30, width: 33,
                            z: -1, x: 1057, y: 245, color: '#888888')
    @coords_off_icon = Image.new("img/ui/coords_off_icon.png", height: 30, width: 30,
                            z: -1, x: 1095, y: 245, color: '#888888')
    @coords_on_icon = Image.new("img/ui/coords_on_icon.png", height: 30, width: 30,
                            z: 1, x: 1095, y: 245, color: '#888888')
    @lgl_off_icon = Image.new("img/ui/legal_off.png", height: 30, width: 30,
                            z: -1, x: 1130, y: 245, color: '#888888')
    @lgl_on_icon = Image.new("img/ui/legal_on.png", height: 30, width: 30,
                            z: 1, x: 1130, y: 245, color: '#888888')
    @floppy_icon = Image.new("img/ui/floppy.png", height: 30, width: 30,
                            z: 1, x: 1167, y: 245, color: '#888888')
    @sound_on_icon = Image.new("img/ui/sound_on.png", height: 30, width: 30,
                            z: 1, x: 1202, y: 245, color: '#888888')
    @sound_off_icon = Image.new("img/ui/sound_off.png", height: 30, width: 30,
                            z: -1, x: 1202, y: 245, color: '#888888')
    @claim_btn = Image.new("img/ui/claim_btn.png", height: 30, width: 195, z: -1,
                      x: 1030, y: 402, color: '#7c0000')
    @claim_txt1 = Text.new("claim draw", x:1076, y: 407, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @claim_txt2 = Text.new("   of position", x:1040, y: 361, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @claim_txt3 = Text.new(" 50 moves without", x:1036, y: 307, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @claim_txt4 = Text.new("    capture or", x:1036, y: 334, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @claim_txt5 = Text.new("    pawn move", x:1040, y: 361, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @draw_txt1 = Text.new("  Draw offered!", x:1042, y: 294, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @draw_txt2 = Text.new("    to decline", x:1038, y: 367, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @draw_txt3 = Text.new("agree draw", x:1076, y: 407, z: -1, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @play_on_txt = Text.new("     play on", x:1042, y: 340, z: -1, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @new_icon = Image.new("img/ui/swords.png", height: 36, width: 36,
                            z: 2, x: 1062, y: 452, color: '#888888')
    @draw_icon = Image.new("img/ui/hand.png", height: 28, width: 36,
                            z: 2, x: 1108, y: 456, color: '#888888')
    @res_icon = Image.new("img/ui/flag.png", height: 36, width: 36,
                            z: 2, x: 1154, y: 452, color: '#888888')
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

  def show_claim
    @claim_btn.z = 3
    @claim_txt1.z = 4
    if @claim == "3-fold repetition!"
      @g_o_txt9.x, @g_o_txt9.y, @g_o_txt9.z = 1041, 307, 1
      @g_o_txt10.x, @g_o_txt10.y, @g_o_txt10.z = 1036, 334, 1
      @claim_txt2.z = 1
    elsif @claim == "50-move rule!"
      @claim_txt3.z = 1
      @claim_txt4.z = 1
      @claim_txt5.z = 1
    end
  end

  def hide_claim
    @claim_btn.z = -1
    @claim_txt1.z = -1
    if @claim == "3-fold repetition!"
      @g_o_txt9.z, @g_o_txt10.z, @claim_txt2.z = -1, -1, -1
    elsif @claim == "50-move rule!"
      @claim_txt3.z = -1
      @claim_txt4.z = -1
      @claim_txt5.z = -1
    end
  end

  def show_offer
    @draw_txt1.z = 1
    @play_on_txt.z = 1
    @draw_txt2.z = 1
    @draw_txt3.z = 3
    @claim_btn.z = 1
  end

  def hide_offer
    @draw_txt1.z = -1
    @play_on_txt.z = -1
    @draw_txt2.z = -1
    @draw_txt3.z = -1
    @claim_btn.z = -1
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
    if @draw_offer == true
      info_off
      @draw_offer = false
      info_on
    end
    if game.claim != ''
      info_off
      @claim = game.claim
      info_on
    elsif @claim != ''
      info_off
      @claim = ''
      info_on
    end
    flip_if_needed(posn, board, game) if @autoflip == true
    if game.game_over != ''
      info_off
      @game_over = game.game_over
      info_on
    end
  end

  def game_over
    if @game_over == 'checkmate!'
      @to_move_ind.z = -1
      if @ply % 2 == 0
        @g_o_txt2b.x, @g_o_txt2b.y, @g_o_txt2b.z = 1036, 358, 2
      else
        @g_o_txt2a.x, @g_o_txt2a.y, @g_o_txt2a.z = 1036, 358, 2
      end
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
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
      @g_o_txt9.x, @g_o_txt9.y, @g_o_txt9.z = 1041, 375, 2
      @g_o_txt10.x, @g_o_txt10.y, @g_o_txt10.z = 1036, 402, 2
    elsif @game_over == 'draw_agreed'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1042, 358, 2
      @g_o_txt11.z = 2
    end
  end

  def event(x, y, event_type, posn = nil, board = nil, game = nil)
    if x > 1020 && x < 1240 && y > 245 && y < 275 # button icons
      info_off if @hover == ''

      if x > 1020 && x < 1055 # flip button
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'flip'
          hover_on('flip') if @hover != 'flip'
        else # event_type == 'click' (flip board)
          flip_board(posn, board, game)
          hover_on('flip')
        end
      elsif x > 1055 && x < 1093 # autoflip button
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
            flip_if_needed(posn, board, game) if @game_over == ''
          end
          hover_on('autoflip')
        end
      elsif x > 1093 && x < 1125 # coords button
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
      elsif x > 1126 && x < 1162 # legal squares
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'legal'
          hover_on('legal') if @hover != 'legal'
        else # event_type == 'click' (toggle legal squares highlighting)
          if @legal_sqs == true
            hover_off
            @legal_sqs = false
          else
            hover_off
            @legal_sqs = true
          end
          hover_on('legal')
        end
      elsif x > 1163 && x < 1198 # save / load
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'save_load'
          hover_on('save_load') if @hover != 'save_load'
        end
      elsif x > 1199 && x < 1240
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'sound'
          hover_on('sound') if @hover != 'sound'
        else # event_type == 'click' (sound on / off)
          if @sound == true
            hover_off
            @sound = false
          else
            hover_off
            @sound = true
          end
          hover_on('sound')
        end
      end

    elsif x > 1060 && x < 1192 && y > 450 && y < 488 # new game, draw, resign btns
      info_off if @hover == ''
      if x > 1060 && x < 1102 # new game
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'new'
          hover_on('new') if @hover != 'new'
        end

      elsif x >= 1102 && x < 1152 # draw offer button
        if @draw_offer == false && event_type == 'hover'
          hover_off if @hover != '' && @hover != 'draw'
          if @hover != 'draw'
            if @claim == '' && @game_over == ''
              hover_on('draw')
            else
              info_on
              @hover = ''
            end
          end
        elsif @draw_offer == true && event_type == 'hover'
          hover_off
          info_off
          info_on
          @hover = ''
        elsif @draw_offer == false && @claim == '' && @game_over == ''
          hover_off
          info_off
          @draw_offer = true
          info_on
          @hover = ''
        else
          info_on
        end

      elsif x >= 1152 && x < 1192 # resign
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'resign'
          if @hover != 'resign'
            if @claim == '' && @game_over == ''
              hover_on('resign')
            else
              info_on
              @hover = ''
            end
          end
        end

    end

    elsif (@claim != '' || @draw_offer == true) && x > 1029 && x < 1226 && y > 401 && y < 433 # claim_btn
      if event_type == 'hover'
        hover_off if @hover != '' && @hover != 'claim'
        hover_on('claim') if @hover != 'claim'
      elsif @claim != '' # event_type == 'click' (claim draw)
        game.game_over = @claim
        info_off
        @game_over = @claim
        @claim = ''
        info_on
        @to_move_ind.z = -1
      elsif @draw_offer == true
        game.game_over = 'draw_agreed'
        info_off
        @game_over = 'draw_agreed'
        @draw_offer = false
        info_on
        @to_move_ind.z = -1
      end
    elsif @hover != '' # not in button icons nor claim button area
      hover_off
      info_on
      @hover = ''
    end
  end

  def hover_on(element)
    if element == 'coords'
      if @coords_on == false
        @coords_off_icon.color = '#ffffff'
        @coords_off_icon.z = 1
        @coords_on_icon.z = -1
        @tooltip1.z = 1
      else
        @coords_on_icon.color = '#ffffff'
        @coords_on_icon.z = 1
        @coords_off_icon.z = -1
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
    elsif element == 'legal'
      if @legal_sqs == true
        @tooltip7.z = 1
        @lgl_on_icon.z = 1
        @lgl_off_icon.z = -1
        @lgl_on_icon.color = '#ffffff'
      else
        @tooltip6.z = 1
        @lgl_off_icon.z = 1
        @lgl_on_icon.z = -1
        @lgl_off_icon.color = '#ffffff'
      end
      @hover = 'legal'
    elsif element == 'save_load'
      @tooltip11.z = 1
      @floppy_icon.color = '#ffffff'
      @hover = 'save_load'
    elsif element == 'sound'
      if @sound == true
        @tooltip12.z = 1
        @sound_on_icon.z = 1
        @sound_off_icon.z = -1
        @sound_on_icon.color = '#ffffff'
      else
        @tooltip13.z = 1
        @sound_off_icon.z = 1
        @sound_on_icon.z = -1
        @sound_off_icon.color = '#ffffff'
      end
      @hover = 'sound'
    elsif element == 'new'
      @tooltip8.z = 1
      @new_icon.color = '#ffffff'
      @hover = 'new'
    elsif element == 'draw'
      @tooltip9.z = 1
      @draw_icon.color = '#ffffff'
      @hover = 'draw'
    elsif element == 'resign'
      @tooltip10.z = 1
      @res_icon.color = '#ffffff'
      @hover = 'resign'
    elsif element == 'claim'
      @claim_btn.color = '#ff0000'
      @hover = 'claim'
    end
  end

  def hover_off
    if @hover == 'coords'
      if @coords_on == false
        @coords_off_icon.color = '#888888'
        @tooltip1.z = -1
      else
        @coords_on_icon.color = '#888888'
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
    elsif @hover == 'legal'
      if @legal_sqs == true
        @lgl_on_icon.color = '#888888'
        @tooltip7.z = -1
      else
        @lgl_off_icon.color = '#888888'
        @tooltip6.z = -1
      end
    elsif @hover == 'save_load'
      @floppy_icon.color = '#888888'
      @tooltip11.z = -1
    elsif @hover == 'sound'
      if @sound == true
        @sound_on_icon.color = '#888888'
        @tooltip12.z = -1
      else
        @sound_off_icon.color = '#888888'
        @tooltip13.z = -1
      end
    elsif @hover == 'new'
      @new_icon.color = '#888888'
      @tooltip8.z = -1
    elsif @hover == 'draw'
      @draw_icon.color = '#888888'
      @tooltip9.z = -1
    elsif @hover == 'resign'
      @res_icon.color = '#888888'
      @tooltip10.z = -1
    elsif @hover == 'claim'
      @claim_btn.color = '#7c0000'
    end
  end

  def info_on
    if @game_over != ''
      game_over
    elsif @claim != ''
      show_claim
    elsif @draw_offer == true
      show_offer
    else
      @prog_txt.z = 1
    end
  end

  def info_off
    if @game_over != ''
      hide_game_over
    elsif @claim != ''
      hide_claim
    elsif @draw_offer == true
      hide_offer
    else
      @prog_txt.z = -1
    end
  end

  def update_info
    info_off
    info_on
  end

  def hide_game_over
    @g_o_txt1.z = -1
    @g_o_txt2a.z = -1
    @g_o_txt2b.z = -1
    @g_o_txt3.z = -1
    @g_o_txt4.z = -1
    @g_o_txt5.z = -1
    @g_o_txt6.z = -1
    @g_o_txt7.z = -1
    @g_o_txt8.z = -1
    @g_o_txt9.z = -1
    @g_o_txt10.z = -1
    @g_o_txt11.z = -1
  end

end
