class UI
  attr_accessor :coords
  attr_accessor :flipped
  attr_accessor :legal_sqs
  attr_accessor :menu
  attr_accessor :new_game
  attr_accessor :review
  attr_accessor :ply
  attr_accessor :rev_ply
  attr_accessor :move

  def initialize
    @hover = ''
    @coords = true
    @coords_on = true
    @flipped = false
    @autoflip = false
    @legal_sqs = true
    @sound = true
    @draw_offer = false
    @resign = false
    @menu = 'off'
    @new_game = false
    @claim = ''
    @ply = 0
    @review = false
    @rev_ply = 1
    @rev_move = nil
    @rev_posn = []
    @rev_check = false
    @checks = 0
    @game_over = ''
    @moves_txts = []
    @title_w = Image.new("img/ui/title_w.png", height: 50, width: 128, z: 2)
    @title_b = Image.new("img/ui/title_b.png", height: 50, width: 128, z: 2)
    @coords = Image.new("img/ui/coords.png", height: 644, width: 646, x: 290, y: 68, z: 2)
    @to_move_bot = [1002, 619]
    @to_move_top = [1002, 62]
    @title_top = [1020, 60]
    @title_bot = [1020, 617]
    @material_top = [1160, 71]
    @material_bot = [1160, 628]
    @w_material = 39
    @b_material = 39
    @w_diff = 0
    @b_diff = 0
    @winner = ''
    @list_offset = 0
    @posn_list = []
    @key_delay = false
    @autosave = true
    @last_save = 'none'
    @move = Sound.new('./audio/move.wav')
    @capture = Sound.new('./audio/capture.wav')
    create_texts
    create_icons
    create_menus
  end

  def reset_ui
    hover_off
    @flipped = false
    @ply = 0
    @hover = ''
    @game_over = ''
    @moves_txts.each {|e| e.remove}
    @moves_txts = []
    @rev_posn = []
    @posn_list = []
    @list_offset = 0
    @review = false
    @rev_ply = 1
    @rev_check = false
    @to_move_ind.add
    @w_material_text.remove
    @b_material_text.remove
    @w_material_text = nil
    @b_material_text = nil
    @w_material_text = Text.new("39 (0)", x:1160, y: 628, z: 2, size: 24,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @b_material_text = Text.new("39 (0)", x:1160, y: 71, z: 2, size: 24,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @rev_move.remove if @rev_move != nil
    @rev_move = nil
    @last_save = 'none'
    place_defaults
    refresh_info
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

  def update_move_list(game)
    def set_x_posn
      if @ply < 19
        @moves_txts[-1].x = 72
      elsif @ply > 198 # check this when overflow offset implemented
        @moves_txts[-1].x = 52
      else
        @moves_txts[-1].x = 62
      end
    end


    def create_half_move(game, y)
      @moves_txts << Text.new("#{(@ply + 1) / 2}. #{game.pgn_list[-1]}",
                        y: y, z: 2, size: 20, color: '#888888',
                        font: 'fonts/UbuntuMono-R.ttf')
      set_x_posn
    end

    def create_full_move(game, y)
      spaces_str = " " * (7 - game.pgn_list[-2].length)
      @moves_txts[-1].remove
      @moves_txts[-1] = nil
      @moves_txts[-1] = Text.new("#{(@ply + 1) / 2}. #{game.pgn_list[-2]}#{spaces_str} #{game.pgn_list[-1]}",
                        y: y, z: 2, size: 20, color: '#888888',
                        font: 'fonts/UbuntuMono-R.ttf')
      set_x_posn
    end

    new_offset = 0
    new_offset += 1 if @game_over != ''

    if @ply > 58 || (@ply > 56 && @game_over == '')
      new_offset = ((@ply - 57) / 2.floor)
      new_offset += 1 if @game_over != ''
      (new_offset - @list_offset).times do |i|
        i += @list_offset
        @moves_txts[i].remove
        @moves_txts.each {|e| e.y -= 20}
      end
      @list_offset = new_offset
    end

    y = 48 + (((@ply - 1) / 2.floor) * 20) - (@list_offset * 20)

    if @game_over != ''
      y = y += 20
      if game.moves[-1][3].include?('1-0')
        @moves_txts << Text.new("1-0", x: 137, y: y, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#888888')
      elsif
        game.moves[-1][3].include?('0-1')
        @moves_txts << Text.new("0-1", x: 137, y: y, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#888888')
      else
        @moves_txts << Text.new("1/2-1/2", x: 117, y: y, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#888888')
      end
    elsif @ply % 2 == 1
      create_half_move(game, y)
    else
      create_full_move(game, y)
    end
    @rev_ply = @ply
    highlight_move(game)
  end

  def move_update(posn, board, game)
    @posn_list = @posn_list + posn
    @ply = game.ply
    @checks = game.checks
    update_move_ind
    if game.w_material != @w_material || game.b_material != @b_material
      @w_material, @b_material = game.w_material, game.b_material
      material_diff
      @w_material_text.remove
      @b_material_text.remove
      @w_material_text = nil
      @b_material_text = nil
      @w_material_text = Text.new("#{@w_material} (#{@w_diff})", x:1160, y: 628,
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
      @b_material_text = Text.new("#{@b_material} (#{@b_diff})", x:1160, y: 71,
      font: 'fonts/UbuntuMono-R.ttf', size: 24, color: '#ffffff', z: 2)
    end
    flip_if_needed(posn, board, game) if @autoflip == true
    update_move_list(game)
    if @draw_offer == true
      info_off
      @draw_offer = false
      info_on
    elsif @resign == true
      info_off
      @resign = false
      info_on
    elsif game.claim != ''
      info_off
      @claim = game.claim
      info_on
    elsif @claim != ''
      info_off
      @claim = ''
      info_on
    elsif game.game_over != ''
      info_off
      @game_over = game.game_over
      info_on
    end
    play_sound(game.moves[-1][3]) if @sound == true
    update_move_list(game) if @game_over != ''
    #startTime = Time.now # debug: monitor responsiveness
    last_save = @last_save
    @last_save = Io.autosave(last_save, game) if @autosave == true
    #puts "time to delete/create autosave: #{(duration = Time.now - startTime).to_s} s"
  end

  def play_sound(details)
    if details.include?('x')
      @capture.play
    else
      @move.play
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
    if @checks > 0 || @rev_check == true
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

  def swap_posns(board, prev_posn, rev_posn)
    64.times do |i|
      if prev_posn[i] != rev_posn[i] && prev_posn[i] != '---'
        piece = board.game_pieces.detect {|e| e.name == prev_posn[i]}
        piece.icon.z = -1
      end
    end

    64.times do |i|
      if prev_posn[i] != rev_posn[i] && rev_posn[i] != '---'
        piece = board.game_pieces.detect {|e| e.name == rev_posn[i]}
        i = 63 - i if @flipped == true
        piece.move_to_square(i)
        piece.icon.z = 5
      end
    end
  end

  def replay_king_check(move, game)
    if move[3].include?('+')
      @rev_check = true
      if move[0][0] == 'w'
        square = @rev_posn.find_index('bk0')
      else
        square = @rev_posn.find_index('wk0')
      end
      game.place_red_sq(square)
      game.red_square.image.add
    else
      @rev_check = false
      game.red_square.image.remove
    end
  end

  def highlight_move(game)
    @rev_move.remove if @rev_move != nil
    @rev_move = nil
    if @rev_ply != 0
      y = 48 + (((@rev_ply - 1) / 2.floor) * 20) - (@list_offset * 20)
      if @rev_ply % 2 == 1
        x = 102
      else
        x = 182
      end
      @rev_move = Text.new("#{game.pgn_list[@rev_ply - 1]}", x: x, y: y,
                            z: 5, size: 20, color: '#ffffff',
                            font: 'fonts/UbuntuMono-R.ttf')
    end
  end

  def step_back(game, board)
    if @ply > 0 && @rev_ply >= 1
      if @review == false
        @rev_ply = @ply
        @review = true
      end
      @rev_ply -= 1
      move = game.moves[@rev_ply - 1]

      if @rev_ply != 0
        @rev_posn = @posn_list[((@rev_ply - 1) * 64)..((@rev_ply * 64) - 1)]
      else
        @rev_posn = Utilities.start_posn_w_pcs
      end

      rev_posn = @rev_posn
      prev_posn = @posn_list[(64 + ((@rev_ply -1) * 64))..(63 + @rev_ply * 64)]

      swap_posns(board, prev_posn, rev_posn)
      board.start_end_squares(move[1], move[2]) if @rev_ply != 0
      board.hide_start_end if @rev_ply == 0
      replay_king_check(move, game)

      if @rev_ply > 0
        if @rev_ply / 2.floor < @moves_txts.length - 28 && @rev_ply % 2 == 0 # scroll move list
          @moves_txts.each {|e| e.y += 20}
          @list_offset -= 1
          @moves_txts[29 + @list_offset].remove
          @moves_txts[@list_offset].add
        end
      end
      highlight_move(game)
      play_sound(game.moves[@rev_ply][3]) if @sound == true
    end
  end

  def step_fwd(game, board)
    def scroll_fwd
      @moves_txts.each {|e| e.y -= 20}
      @list_offset += 1
      @moves_txts[28 + @list_offset].add
      @moves_txts[@list_offset - 1].remove
    end

    if @rev_ply < @ply
      move = game.moves[@rev_ply]
      @rev_ply += 1

      if @rev_ply != 1
        prev_posn = @posn_list[((@rev_ply - 2) * 64)..(((@rev_ply - 1) * 64) - 1)]
      else
        prev_posn = Utilities.start_posn_w_pcs
      end

      @rev_posn = @posn_list[((@rev_ply -1) * 64)..((@rev_ply * 64) - 1)]
      rev_posn = @rev_posn

      swap_posns(board, prev_posn, rev_posn)
      board.start_end_squares(move[1], move[2])
      replay_king_check(move, game)

      if @rev_ply <= @ply
        if @rev_ply / 2.floor > @list_offset + 28 # scroll move list
          if @rev_ply % 2 == 1
            scroll_fwd
          end
          if @rev_ply == @ply && @game_over != ''
            scroll_fwd
          end
        end
        @review = false if @rev_ply == @ply
      else
        @review = false
      end
      highlight_move(game)
      play_sound(move[3]) if @sound == true
    end
  end

  def go_to_end(game, board)
    @rev_ply = @ply
    rev_posn = @posn_list[-64..-1]
    prev_posn = @rev_posn
    @rev_posn = rev_posn
    swap_posns(board, prev_posn, rev_posn)
    if game.moves[-1][3].include?('-')
      move = game.moves[-2]
    else
      move = game.moves[-1]
    end

    board.start_end_squares(move[1], move[2])
    replay_king_check(move, game)

    if @moves_txts.length > 29 # scroll move list
      @list_offset = @moves_txts.length - 29
      @list_offset.times do |i|
        @moves_txts[i].y = 28 - ((@list_offset - i - 1) * 20)
        @moves_txts[i].remove
      end
      29.times do |i|
        @moves_txts[i + @list_offset].y = 48 + (i * 20)
        @moves_txts[i + @list_offset].add
      end
    end
    highlight_move(game)
    play_sound(move[3]) if @sound == true
    @review = false
  end

  def go_to_start(game, board)
    if @review == false
      @review = true
    end
    rev_posn = Utilities.start_posn_w_pcs
    prev_posn = @posn_list[((@rev_ply - 1) * 64)..((@rev_ply * 64) - 1)]
    @rev_posn = rev_posn
    swap_posns(board, prev_posn, rev_posn)
    @rev_ply = 0
    board.hide_start_end
    @rev_check = false
    game.red_square.image.remove
    @rev_move.remove if @rev_move != nil
    @rev_move = nil

    if @moves_txts.length > 29 # scroll move list
      @list_offset = @moves_txts.length - 29
      29.times do |i|
        @moves_txts[i].y = 48 + (i * 20)
        @moves_txts[i].add
      end
      @list_offset.times do |i|
        @moves_txts[i + 29].y = 48 + ((29 + i) * 20)
        @moves_txts[i + 29].remove
      end
    end

    @list_offset = 0
  end

  def event(x, y, event_type, posn = nil, board = nil, game = nil)
    def add_draw_to_moves(game)
      game.pgn = game.pgn + ' 1/2-1/2'
      game.moves << ['', nil, nil, '1/2-1/2']
      update_move_list(game)
    end

    if x > 1020 && x < 1240 && y > 245 && y < 275 # button icons
      info_off if @hover == ''

      if x > 1020 && x < 1055 # flip button
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'flip'
          hover_on('flip') if @hover != 'flip'
        else # event_type == 'click' (flip board)
          posn = @rev_posn if @review == true
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
          if @coords_on == true
            @coords.remove
            hover_off
            @coords_on = false
          else
            @coords.add
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
      elsif x > 1163 && x < 1198 # load / save
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'save_load'
          hover_on('save_load') if @hover != 'save_load'
        else
          @menu = 'load_save'
          hover_off
          show_menu_load_save
        end
      elsif x > 1199 && x < 1240 # sound on / off
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
        else
          @menu = 'new'
          hover_off
          show_menu_new
        end

      elsif x >= 1102 && x < 1152 # draw offer button
        if @draw_offer == false && event_type == 'hover'
          hover_off if @hover != '' && @hover != 'draw'
          if @hover != 'draw'
            if @claim == '' && @game_over == '' && @resign == false
              hover_on('draw')
            else
              info_on
              @hover = ''
            end
          end
        elsif @draw_offer == true && event_type == 'hover'
          hover_off
          refresh_info
          @hover = ''
        elsif @draw_offer == false && @claim == '' && @game_over == '' &&
            @resign == false && @ply > 0
          hover_off
          info_off
          @draw_offer = true
          info_on
          @hover = ''
        elsif @ply > 0
          info_on
        end

      elsif x >= 1152 && x < 1192 # resign
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'resign'
          if @hover != 'resign'
            if @claim == '' && @game_over == '' && @resign == false
              hover_on('resign')
            else
              info_on
              @hover = ''
            end
          end
        elsif @resign == true && event_type == 'hover'
          hover_off
          refresh_info
          @hover = ''
        elsif @resign == false && @claim == '' && @game_over == '' && @ply > 0
          hover_off
          info_off
          @draw_offer = false if @draw_offer == true
          @resign = true
          info_on
          @hover = ''
        elsif @ply > 0
          info_on
        end
      end

    elsif (@claim != '' || @draw_offer == true || @resign == true) &&
            x > 1029 && x < 1226 && y > 401 && y < 433 # claim_btn
      if event_type == 'hover'
        hover_off if @hover != '' && @hover != 'claim'
        hover_on('claim') if @hover != 'claim'
      elsif @claim != '' # event_type == 'click' (claim draw)
        game.game_over = @claim
        info_off
        @game_over = @claim
        add_draw_to_moves(game)
        @claim = ''
        info_on
      elsif @draw_offer == true
        game.game_over = 'draw_agreed'
        info_off
        @game_over = 'draw_agreed'
        add_draw_to_moves(game)
        @draw_offer = false
        info_on
      elsif @resign == true
        game.game_over = 'resignation'
        if @ply % 2 == 0
          game.pgn = game.pgn + ' 0-1'
          game.moves << ['', nil, nil, '0-1']
        else
          game.pgn = game.pgn + ' 1-0'
          game.moves << ['', nil, nil, '1-0']
        end
        info_off
        @game_over = 'resignation'
        @resign = false
        info_on
        update_move_list(game)
      end

    elsif x > 59 && x < 247 && y > 637 && y < 675 # move list navigation btns
      if x < 104 # go to start
        if event_type == 'hover'
          info_off
          hover_off if @hover != '' && @hover != 'start'
          hover_on('start') if @hover != 'start'
        else # set up start posn, when click 'go to start'
          go_to_start(game, board)
        end
      elsif x > 118 && x < 153 # step back
        if event_type == 'hover'
          info_off
          hover_off if @hover != '' && @hover != 'back'
          hover_on('back') if @hover != 'back'
        else # click event
          step_back(game, board)
        end
      elsif x > 152 && x < 187 # step fwd
        if event_type == 'hover'
          info_off
          hover_off if @hover != '' && @hover != 'fwd'
          hover_on('fwd') if @hover != 'fwd'
        else # click event
          step_fwd(game, board)
        end
      elsif x > 202 && x < 247 # go to end
        if event_type == 'hover'
          info_off
          hover_off if @hover != '' && @hover != 'end'
          hover_on('end') if @hover != 'end'
        else # click event
          go_to_end(game, board)
        end
      elsif event_type != 'click'
        hover_off
        @hover = ''
      end

    elsif @hover != '' # not in button icons nor claim button area
      hover_off
      info_on
      @hover = ''
    end
  end

  def menu_event(x, y, event_type)
    def autosave_checkbox(event_type)
      if event_type == 'hover'
        hover_off if @hover != '' && @hover != 'autosave'
        hover_on('autosave') if @hover != 'autosave'
      else
        if @autosave == true
          if @menu == 'new'
            hide_menu_new
            @autosave = false
            show_menu_new
          else
            hide_menu_load_save
            @autosave = false
            show_menu_load_save
          end
        else
          if @menu == 'new'
            hide_menu_new
            @autosave = true
            show_menu_new
          else
            hide_menu_load_save
            @autosave = true
            show_menu_load_save
          end
        end
      end
    end

    if x > 539 && x < 736 && y > 539 && y < 571 # close btn
      if event_type == 'hover'
        hover_off if @hover != '' && @hover != 'close'
        hover_on('close') if @hover != 'close'
      else
        if @menu == 'new'
          hide_menu_new
        elsif @menu == 'load_save'
          hide_menu_load_save
        end
        @menu = 'off'
        hover_off
        @hover = ''
      end
    elsif @menu == 'new'
      if x > 539 && x < 736 && y > 199 && y < 231 # human v human btn
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'human_v_human'
          hover_on('human_v_human') if @hover != 'human_v_human'
        else
          @new_game = true
          @menu = 'off'
          hide_menu_new
          reset_ui
        end
      elsif x > 539 && x < 736 && y > 259 && y < 291 # human v engine btn
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'human_v_engine'
          hover_on('human_v_engine') if @hover != 'human_v_engine'
        else
          # click event
        end
      elsif x > 539 && x < 736 && y > 319 && y < 351 # engine v engine btn
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'engine_v_engine'
          hover_on('engine_v_engine') if @hover != 'engine_v_engine'
        else
          # click event
        end
      elsif x > 539 && x < 736 && y > 399 && y < 431 # engine settings btn
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'engine_settings'
          hover_on('engine_settings') if @hover != 'engine_settings'
        else
          # click event
        end
      elsif x > 539 && x < 567 && y > 473 && y < 501 # autosave checkbox
        autosave_checkbox(event_type)
      elsif @hover != '' # not in button icons nor claim button area
        hover_off
        @hover = ''
      end
    elsif @menu == 'load_save'
      if x > 495 && x < 789 && y > 189 && y < 221 # load complete btn
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'load_complete'
          hover_on('load_complete') if @hover != 'load_complete'
        else
          # click event
        end
      elsif x > 495 && x < 789 && y > 249 && y < 281 # load INcomplete btn
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'load_incomplete'
          hover_on('load_incomplete') if @hover != 'load_incomplete'
        else
          # click event
        end
      elsif x > 539 && x < 736 && y > 359 && y < 391 # save btn
        if event_type == 'hover'
          hover_off if @hover != '' && @hover != 'save'
          hover_on('save') if @hover != 'save'
        else
          # click event #
        end
      elsif x > 539 && x < 567 && y > 439 && y < 467 # autosave checkbox
        autosave_checkbox(event_type)
      elsif @hover != '' # not in button icons nor claim button area
        hover_off
        @hover = ''
      end
    end



  end

  def hover_on(element)
    if element == 'coords'
      if @coords_on == false
        @coords_off_icon.color = '#ffffff'
        @coords_off_icon.add
        @coords_on_icon.remove
        @tooltip1.add
      else
        @coords_on_icon.color = '#ffffff'
        @coords_on_icon.add
        @coords_off_icon.remove
        @tooltip2.add
      end
      @hover = 'coords'
    elsif element == 'flip'
      @tooltip3.add
      @flip_icon.color = '#ffffff'
      @hover = 'flip'
    elsif element == 'autoflip'
      if @autoflip == true
        @tooltip4.add
        @autoflip_on.add
        @autoflip_off.remove
        @autoflip_on.color = '#ffffff'
      else
        @tooltip5.add
        @autoflip_off.add
        @autoflip_on.remove
        @autoflip_off.color = '#ffffff'
      end
      @hover = 'autoflip'
    elsif element == 'legal'
      if @legal_sqs == true
        @tooltip7.add
        @lgl_on_icon.add
        @lgl_off_icon.remove
        @lgl_on_icon.color = '#ffffff'
      else
        @tooltip6.add
        @lgl_off_icon.add
        @lgl_on_icon.remove
        @lgl_off_icon.color = '#ffffff'
      end
      @hover = 'legal'
    elsif element == 'save_load'
      @tooltip11.add
      @floppy_icon.color = '#ffffff'
      @hover = 'save_load'
    elsif element == 'sound'
      if @sound == true
        @tooltip12.add
        @sound_on_icon.add
        @sound_off_icon.remove
        @sound_on_icon.color = '#ffffff'
      else
        @tooltip13.add
        @sound_off_icon.add
        @sound_on_icon.remove
        @sound_off_icon.color = '#ffffff'
      end
      @hover = 'sound'
    elsif element == 'new'
      @tooltip8.add
      @new_icon.color = '#ffffff'
      @hover = 'new'
    elsif element == 'draw'
      @tooltip9.add
      @draw_icon.color = '#ffffff'
      @hover = 'draw'
    elsif element == 'resign'
      @tooltip10.add
      @res_icon.color = '#ffffff'
      @hover = 'resign'
    elsif element == 'claim'
      @claim_btn.color = '#ff0000'
      @hover = 'claim'
    elsif element == 'close'
      @menu_btn5.color = '#ff0000'
      @hover = 'close'
    elsif element == 'human_v_human'
      @menu_btn1.color = '#018dc1'
      @hover = 'human_v_human'
    elsif element == 'human_v_engine'
      @menu_btn2.color = '#007bff'
      @hover = 'human_v_engine'
    elsif element == 'engine_v_engine'
      @menu_btn3.color = '#5500f4'
      @hover = 'engine_v_engine'
    elsif element == 'engine_settings'
      @menu_btn4.color = '#666666'
      @hover = 'engine_settings'
    elsif element == 'load_complete'
      @menu_btn6.color = '#01a500'
      @hover = 'load_complete'
    elsif element == 'load_incomplete'
      @menu_btn7.color = '#00a05a'
      @hover = 'load_incomplete'
    elsif element == 'save'
      @menu_btn8.color = '#018dc1'
      @hover = 'save'
    elsif element == 'autosave'
      @checkbox.remove
      @checkbox_hover.add
      @hover = 'autosave'
    elsif element == 'start'
      @tooltip14.add
      @start.color = '#ffffff'
      @hover = 'start'
    elsif element == 'back'
      @tooltip15.add
      @back.color = '#ffffff'
      @hover = 'back'
    elsif element == 'fwd'
      @tooltip16.add
      @fwd.color = '#ffffff'
      @hover = 'fwd'
    elsif element == 'end'
      @tooltip17.add
      @end.color = '#ffffff'
      @hover = 'end'
    end
  end

  def hover_off
    if @hover == 'coords'
      if @coords_on == false
        @coords_off_icon.color = '#888888'
        @tooltip1.remove
      else
        @coords_on_icon.color = '#888888'
        @tooltip2.remove
      end
    elsif @hover == 'flip'
      @flip_icon.color = '#888888'
      @tooltip3.remove
    elsif @hover == 'autoflip'
      if @autoflip == true
        @autoflip_on.color = '#888888'
        @tooltip4.remove
      else
        @autoflip_off.color = '#888888'
        @tooltip5.remove
      end
    elsif @hover == 'legal'
      if @legal_sqs == true
        @lgl_on_icon.color = '#888888'
        @tooltip7.remove
      else
        @lgl_off_icon.color = '#888888'
        @tooltip6.remove
      end
    elsif @hover == 'save_load'
      @floppy_icon.color = '#888888'
      @tooltip11.remove
    elsif @hover == 'sound'
      if @sound == true
        @sound_on_icon.color = '#888888'
        @tooltip12.remove
      else
        @sound_off_icon.color = '#888888'
        @tooltip13.remove
      end
    elsif @hover == 'new'
      @new_icon.color = '#888888'
      @tooltip8.remove
    elsif @hover == 'draw'
      @draw_icon.color = '#888888'
      @tooltip9.remove
    elsif @hover == 'resign'
      @res_icon.color = '#888888'
      @tooltip10.remove
    elsif @hover == 'claim'
      @claim_btn.color = '#7c0000'
    elsif @hover == 'close'
      @menu_btn5.color = '#7c0000'
    elsif @hover == 'human_v_human'
      @menu_btn1.color = '#006991'
    elsif @hover == 'human_v_engine'
      @menu_btn2.color = '#0058b7'
    elsif @hover == 'engine_v_engine'
      @menu_btn3.color = '#4000b7'
    elsif @hover == 'engine_settings'
      @menu_btn4.color = '#444444'
    elsif @hover == 'load_complete'
      @menu_btn6.color = '#018700'
    elsif @hover == 'load_incomplete'
      @menu_btn7.color = '#008249'
    elsif @hover == 'save'
      @menu_btn8.color = '#006991'
    elsif @hover == 'autosave'
      @checkbox_hover.remove
      @checkbox.add
    elsif @hover == 'start'
      @tooltip14.remove
      @start.color = '#888888'
    elsif @hover == 'back'
      @tooltip15.remove
      @back.color = '#888888'
    elsif @hover == 'fwd'
      @tooltip16.remove
      @fwd.color = '#888888'
    elsif @hover == 'end'
      @tooltip17.remove
      @end.color = '#888888'
    end
  end

  def info_on
    if @review == true
      @rev_txt.add
    elsif @game_over != ''
      game_over
    elsif @claim != ''
      show_claim
    elsif @draw_offer == true
      show_offer
    elsif @resign == true
      show_resign
    else
      @prog_txt.add
    end
  end

  def info_off
    @rev_txt.remove
    if @game_over != ''
      hide_game_over
    elsif @claim != ''
      hide_claim
    elsif @draw_offer == true
      hide_offer
    elsif @resign == true
      hide_resign
    else
      @prog_txt.remove
    end
  end

  def refresh_info
    info_off
    info_on
  end

  def show_claim
    @claim_btn.z = 3
    @claim_txt1.add
    if @claim == "3-fold repetition!"
      @g_o_txt9.x, @g_o_txt9.y = 1041, 307
      @g_o_txt9.add
      @g_o_txt10.x, @g_o_txt10.y = 1036, 334
      @g_o_txt10.add
      @claim_txt2.add
    elsif @claim == "50-move rule!"
      @claim_txt3.add
      @claim_txt4.add
      @claim_txt5.add
    end
  end

  def hide_claim
    @claim_btn.z = -1
    @claim_txt1.remove
    if @claim == "3-fold repetition!"
      @g_o_txt9.remove
      @g_o_txt10.remove
      @claim_txt2.remove
    elsif @claim == "50-move rule!"
      @claim_txt3.remove
      @claim_txt4.remove
      @claim_txt5.remove
    end
  end

  def show_offer
    @draw_txt1.add
    @play_on_txt.x, @play_on_txt.y = 1042, 340
    @play_on_txt.add
    @draw_txt2.add
    @draw_txt3.add
    @claim_btn.z = 1
  end

  def hide_offer
    @draw_txt1.remove
    @play_on_txt.remove
    @draw_txt2.remove
    @draw_txt3.remove
    @claim_btn.z = -1
  end

  def show_resign
    if @ply % 2 == 0
      @res_txt1.add
    else
      @res_txt2.add
    end
    @res_txt3.add
    @play_on_txt.x, @play_on_txt.y = 1042, 350
    @play_on_txt.add
    @res_txt4.add
    @res_txt5.add
    @claim_btn.z = 1
  end

  def hide_resign
    @res_txt1.remove
    @res_txt2.remove
    @res_txt3.remove
    @play_on_txt.remove
    @res_txt4.remove
    @res_txt5.remove
    @claim_btn.z = -1
  end

  def game_over
    @to_move_ind.remove
    if @game_over == 'checkmate!'
      if @ply % 2 == 0
        @g_o_txt2b.x, @g_o_txt2b.y, @g_o_txt2b.z = 1036, 358, 2
        @g_o_txt2b.add
      else
        @g_o_txt2a.x, @g_o_txt2a.y, @g_o_txt2a.z = 1036, 358, 2
        @g_o_txt2a.add
      end
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
      @g_o_txt3.x, @g_o_txt3.y, @g_o_txt3.z = 1036, 387, 2
      @g_o_txt1.add
      @g_o_txt3.add
    elsif @game_over == 'stalemate!'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1042, 358, 2
      @g_o_txt1.add
      @g_o_txt4.add
      @g_o_txt5.add
    elsif @game_over == 'insufficient!'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 294, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1041, 348, 2
      @g_o_txt1.add
      @g_o_txt4.add
      @g_o_txt6.add
      @g_o_txt7.add
    elsif @game_over == '50-move rule!'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1042, 358, 2
      @g_o_txt1.add
      @g_o_txt4.add
      @g_o_txt8.add
    elsif @game_over == '3-fold repetition!'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 294, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1041, 348, 2
      @g_o_txt9.x, @g_o_txt9.y, @g_o_txt9.z = 1041, 375, 2
      @g_o_txt10.x, @g_o_txt10.y, @g_o_txt10.z = 1036, 402, 2
      @g_o_txt1.add
      @g_o_txt4.add
      @g_o_txt9.add
      @g_o_txt10.add
    elsif @game_over == 'draw_agreed'
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
      @g_o_txt4.x, @g_o_txt4.y, @g_o_txt4.z = 1042, 358, 2
      @g_o_txt1.add
      @g_o_txt4.add
      @g_o_txt11.add
    elsif @game_over == 'resignation'
      if @ply % 2 == 0
        @g_o_txt2b.x, @g_o_txt2b.y, @g_o_txt2b.z = 1036, 358, 2
        @g_o_txt2b.add
      else
        @g_o_txt2a.x, @g_o_txt2a.y, @g_o_txt2a.z = 1036, 358, 2
        @g_o_txt2a.add
      end
      @g_o_txt1.x, @g_o_txt1.y, @g_o_txt1.z = 1036, 306, 2
      @g_o_txt1.add
      @g_o_txt12.add
    end
  end

  def hide_game_over
    @g_o_txt1.remove
    @g_o_txt2a.remove
    @g_o_txt2b.remove
    @g_o_txt3.remove
    @g_o_txt4.remove
    @g_o_txt5.remove
    @g_o_txt6.remove
    @g_o_txt7.remove
    @g_o_txt8.remove
    @g_o_txt9.remove
    @g_o_txt10.remove
    @g_o_txt11.remove
    @g_o_txt12.remove
  end

  def show_menu_basics
    @menu_screen.add
    @menu_box.add
    @menu_btn5.add
    @btn5_txt.add
  end

  def hide_menu_basics
    @menu_screen.remove
    @menu_box.remove
    @menu_btn5.remove
    @btn5_txt.remove
  end

  def show_menu_new
    show_menu_basics
    @menu_txt1.add
    @menu_btn1.add
    @menu_btn2.add
    @menu_btn3.add
    @menu_btn4.add
    @btn1_txt.add
    @btn2_txt.add
    @btn3_txt.add
    @btn4_txt.add
    @checkbox.y = 474
    @checkbox_hover.y = 474
    @checkbox.add
    if @autosave == true
      @menu_txt4.y = 476
      @menu_txt4.add
      @tick.y = 477
      @tick.add
    else
      @menu_txt5.y = 476
      @menu_txt5.add
    end
  end

  def hide_menu_new
    hide_menu_basics
    @menu_txt1.remove
    @menu_btn1.remove
    @menu_btn2.remove
    @menu_btn3.remove
    @menu_btn4.remove
    @btn1_txt.remove
    @btn2_txt.remove
    @btn3_txt.remove
    @btn4_txt.remove
    @checkbox.remove
    if @autosave == true
      @menu_txt4.remove
      @tick.remove
    else
      @menu_txt5.remove
    end
  end

  def show_menu_load_save
    show_menu_basics
    @menu_txt2.add
    @menu_txt3.add
    @menu_btn6.add
    @menu_btn7.add
    @menu_btn8.add
    @btn6_txt.add
    @btn7_txt.add
    @btn8_txt.add
    @checkbox.y = 440
    @checkbox_hover.y = 440
    @checkbox.add
    if @autosave == true
      @menu_txt4.y = 442
      @menu_txt4.add
      @tick.y = 443
      @tick.add
    else
      @menu_txt5.y = 442
      @menu_txt5.add
    end
  end

  def hide_menu_load_save
    hide_menu_basics
    @menu_txt2.remove
    @menu_txt3.remove
    @menu_btn6.remove
    @menu_btn7.remove
    @menu_btn8.remove
    @btn6_txt.remove
    @btn7_txt.remove
    @btn8_txt.remove
    @checkbox.remove
    if @autosave == true
      @menu_txt4.remove
      @tick.remove
    else
      @menu_txt5.remove
    end
  end

  def create_texts
    @w_material_text = Text.new("39 (0)", x:1160, y: 628, z: 2, size: 24,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @b_material_text = Text.new("39 (0)", x:1160, y: 71, z: 2, size: 24,
                                font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @prog_txt = Text.new(" Game in progress ", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    # no .remove, as currently is welcome message
    @g_o_txt1 = Text.new("    Game over!", x:1036, y: 294, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    @g_o_txt1.remove
    @g_o_txt2a = Text.new("    White wins", x:1036, y: 358, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt2a.remove
    @g_o_txt2b = Text.new("    Black wins", x:1036, y: 358, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt2b.remove
    @g_o_txt3 = Text.new("   by checkmate", x:1036, y: 387, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt3.remove
    @g_o_txt4 = Text.new("     Draw by", x:1042, y: 358, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt4.remove
    @g_o_txt5 = Text.new("    stalemate", x:1042, y: 387, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt5.remove
    @g_o_txt6 = Text.new("   insufficient", x:1036, y: 375, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    @g_o_txt6.remove
    @g_o_txt7 = Text.new("     material", x:1036, y: 402, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff', )
    @g_o_txt7.remove
    @g_o_txt8 = Text.new("   50-move rule", x:1036, y: 387, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt8.remove
    @g_o_txt9 = Text.new("    threefold", x:1041, y: 375, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt9.remove
    @g_o_txt10 = Text.new("    repetition", x:1036, y: 402, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt10.remove
    @g_o_txt11 = Text.new("    agreement", x:1042, y: 387, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt11.remove
    @g_o_txt12 = Text.new("  by resignation", x:1036, y: 387, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @g_o_txt12.remove
    @tooltip1 = Text.new("  coordinates ON", x:1033, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip1.remove
    @tooltip2 = Text.new("  coordinates OFF", x:1033, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip2.remove
    @tooltip3 = Text.new("    flip board", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip3.remove
    @tooltip4 = Text.new("   autoflip OFF", x:1037, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip4.remove
    @tooltip5 = Text.new("   autoflip ON", x:1037, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip5.remove
    @tooltip6 = Text.new(" legal squares ON", x:1033, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip6.remove
    @tooltip7 = Text.new(" legal squares OFF", x:1033, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip7.remove
    @tooltip8 = Text.new("     new game", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip8.remove
    @tooltip9 = Text.new("    offer draw", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip9.remove
    @tooltip10 = Text.new("      resign", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip10.remove
    @tooltip11 = Text.new(" load / save game", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip11.remove
    @tooltip12 = Text.new("     sound OFF", x:1032, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip12.remove
    @tooltip13 = Text.new("     sound ON", x:1032, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip13.remove
    @tooltip14 = Text.new("    go to start", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip14.remove
    @tooltip15 = Text.new("  step backward", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip15.remove
    @tooltip16 = Text.new("  step forward", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip16.remove
    @tooltip17 = Text.new("    go to end", x:1036, y: 348, z: 2, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @tooltip17.remove
    @claim_txt1 = Text.new("claim draw", x:1076, y: 407, z: 4, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @claim_txt1.remove
    @claim_txt2 = Text.new("   of position", x:1040, y: 361, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @claim_txt2.remove
    @claim_txt3 = Text.new(" 50 moves without", x:1036, y: 307, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @claim_txt3.remove
    @claim_txt4 = Text.new("    capture or", x:1036, y: 334, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @claim_txt4.remove
    @claim_txt5 = Text.new("    pawn move", x:1040, y: 361, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @claim_txt5.remove
    @draw_txt1 = Text.new("  Draw offered!", x:1042, y: 294, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @draw_txt1.remove
    @draw_txt2 = Text.new("    to decline", x:1038, y: 367, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @draw_txt2.remove
    @draw_txt3 = Text.new("agree draw", x:1076, y: 406, z: 4, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @draw_txt3.remove
    @res_txt1 = Text.new("      White;", x:1036, y: 294, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @res_txt1.remove
    @res_txt2 = Text.new("      Black;", x:1036, y: 294, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @res_txt2.remove
    @res_txt3 = Text.new("   confirm, or", x:1040, y: 326, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @res_txt3.remove
    @res_txt4 = Text.new("    to close", x:1040, y: 374, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @res_txt4.remove
    @res_txt5 = Text.new("  resign", x:1076, y: 405, z: 4, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @res_txt5.remove
    @play_on_txt = Text.new("     play on", x:1042, y: 340, z: 2, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @play_on_txt.remove
    @menu_txt1 = Text.new("New Game", x:600, y: 150, z: 7, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @menu_txt1.remove
    @menu_txt2 = Text.new("Load Game", x:600, y: 150, z: 7, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @menu_txt2.remove
    @menu_txt3 = Text.new("Save Game", x:595, y: 330, z: 7, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @menu_txt3.remove
    @menu_txt4 = Text.new("Autosave is ON", x:580, y: 442, z: 7, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @menu_txt4.remove
    @menu_txt5 = Text.new("Autosave is OFF", x:580, y: 442, z: 7, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @menu_txt5.remove
    @btn1_txt = Text.new("human v human", x:574, y: 205, z: 8, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @btn1_txt.remove
    @btn2_txt = Text.new("human v engine", x:574, y: 265, z: 8, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @btn2_txt.remove
    @btn3_txt = Text.new("engine v engine", x:566, y: 325, z: 8, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @btn3_txt.remove
    @btn4_txt = Text.new("engine settings", x:566, y: 405, z: 8, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @btn4_txt.remove
    @btn5_txt = Text.new("close", x:614, y: 545, z: 8, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @btn5_txt.remove
    @btn6_txt = Text.new("load COMPLETE game", x:554, y: 200, z: 8, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @btn6_txt.remove
    @btn7_txt = Text.new("load INCOMPLETE game", x:545, y: 260, z: 8, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @btn7_txt.remove
    @btn8_txt = Text.new("save game", x:595, y: 379, z: 8, size: 20,
                          font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @btn8_txt.remove
    @rev_txt = Text.new("   Review mode ", x:1042, y: 348, z: 4, size: 20,
                            font: 'fonts/UbuntuMono-R.ttf', color: '#ffffff')
    @rev_txt.remove
  end

  def create_icons
    @to_move_ind = Image.new("img/ui/to_move_ind.png", height: 46, width: 15, z: 2)
    @flip_icon = Image.new("img/ui/flip_icon.png", height: 30, width: 33,
                            z: 1, x: 1020, y: 245, color: '#888888')
    @autoflip_off = Image.new("img/ui/autoflip_off.png", height: 30, width: 33,
                            z: 1, x: 1057, y: 245, color: '#888888')
    @autoflip_on = Image.new("img/ui/autoflip_on.png", height: 30, width: 33,
                            z: 1, x: 1057, y: 245, color: '#888888')
    @autoflip_on.remove
    @coords_off_icon = Image.new("img/ui/coords_off_icon.png", height: 30, width: 30,
                            z: 1, x: 1095, y: 245, color: '#888888')
    @coords_off_icon.remove
    @coords_on_icon = Image.new("img/ui/coords_on_icon.png", height: 30, width: 30,
                            z: 1, x: 1095, y: 245, color: '#888888')
    @lgl_off_icon = Image.new("img/ui/legal_off.png", height: 30, width: 30,
                            z: 1, x: 1130, y: 245, color: '#888888')
    @lgl_off_icon.remove
    @lgl_on_icon = Image.new("img/ui/legal_on.png", height: 30, width: 30,
                            z: 1, x: 1130, y: 245, color: '#888888')
    @floppy_icon = Image.new("img/ui/floppy.png", height: 30, width: 30,
                            z: 1, x: 1167, y: 245, color: '#888888')
    @sound_on_icon = Image.new("img/ui/sound_on.png", height: 30, width: 30,
                            z: 1, x: 1202, y: 245, color: '#888888')
    @sound_off_icon = Image.new("img/ui/sound_off.png", height: 30, width: 30,
                            z: 1, x: 1202, y: 245, color: '#888888')
    @sound_off_icon.remove
    @claim_btn = Image.new("img/ui/btn1.png", height: 30, width: 195, z: -1,
                      x: 1030, y: 402, color: '#7c0000')
    @claim_btn.remove
    @new_icon = Image.new("img/ui/swords.png", height: 36, width: 36,
                            z: 2, x: 1062, y: 452, color: '#888888')
    @draw_icon = Image.new("img/ui/hand.png", height: 28, width: 36,
                            z: 2, x: 1108, y: 456, color: '#888888')
    @res_icon = Image.new("img/ui/flag.png", height: 36, width: 36,
                            z: 2, x: 1154, y: 452, color: '#888888')
    @menu_btn1 = Image.new("img/ui/btn1.png", height: 30, width: 195, z: 7,
                            x: 540, y: 200, color: '#006991') # #018dc1
    @menu_btn1.remove
    @menu_btn2 = Image.new("img/ui/btn1.png", height: 30, width: 195, z: 7,
                            x: 540, y: 260, color: '#0058b7') # #007bff
    @menu_btn2.remove
    @menu_btn3 = Image.new("img/ui/btn1.png", height: 30, width: 195, z: 7,
                            x: 540, y: 320, color: '#4000b7') # #5500f4
    @menu_btn3.remove
    @menu_btn4 = Image.new("img/ui/btn1.png", height: 30, width: 195, z: 7,
                            x: 540, y: 400, color: '#444444') # #666666
    @menu_btn4.remove
    @menu_btn5 = Image.new("img/ui/btn1.png", height: 30, width: 195, z: 7,
                            x: 540, y: 540, color: '#7c0000') # #ff0000
    @menu_btn5.remove
    @menu_btn6 = Image.new("img/ui/btn2.png", height: 30, width: 293, z: 7,
                            x: 496, y: 195, color: '#018700') # #01a500
    @menu_btn6.remove
    @menu_btn7 = Image.new("img/ui/btn2.png", height: 30, width: 293, z: 7,
                            x: 496, y: 255, color: '#008249') # #00a05a
    @menu_btn7.remove
    @menu_btn8 = Image.new("img/ui/btn1.png", height: 30, width: 195, z: 7,
                            x: 540, y: 375, color: '#006991') # #018dc1
    @menu_btn8.remove
    @checkbox = Image.new("img/ui/checkbox.png", height: 26, width: 26, z: 7,
                            x: 540, y: 440, color: '#ffffff')
    @checkbox.remove
    @checkbox_hover = Image.new("img/ui/checkbox_hover.png", height: 26, width: 26,
                                z: 7, x: 540, y: 440, color: '#ffffff')
    @checkbox_hover.remove
    @tick = Image.new("img/ui/tick.png", height: 20, width: 20, z: 8,
                            x: 543, y: 443, color: '#ffffff')
    @tick.remove
    @start = Image.new("img/ui/start.png", height: 33, width: 43, z: 2,
                            x: 60, y: 638, color: '#888888')
    @back = Image.new("img/ui/back.png", height: 33, width: 31, z: 2,
                            x: 119, y: 638, color: '#888888')
    @fwd = Image.new("img/ui/fwd.png", height: 33, width: 31, z: 2,
                            x: 155, y: 638, color: '#888888')
    @end = Image.new("img/ui/end.png", height: 33, width: 43, z: 2,
                            x: 203, y: 638, color: '#888888')
  end

  def create_menus
    @menu_screen = Rectangle.new(x: 0, y: 0, z: 5, width: 1280, height: 720,
                            color: [0.5, 0.5, 0.5, 0.5])
    @menu_screen.remove
    @menu_box = Image.new("img/ui/menu1.png", height: 480, width: 480,
                        z: 6, x: 400, y: 120)
    @menu_box.remove
  end
end
