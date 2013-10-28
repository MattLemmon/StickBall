#
# ROUND CHANGE GAMESTATE
#
class RoundChange < Chingu::GameState    
  trait :timer

  def setup

    $window.caption = "Preare for Round #{$round}"

    self.input = { :p => Pause,
                   :r => lambda{current_game_state.setup},
                   :right_shift=>:next,
                   :left_shift=>:next,
                   [:enter, :return] => Field
                 }

    @chant = "Loading Round #{$round}"

    chant
  end

  def next
    push_game_state(Field)
  end

  def chant
    @chant_text = Chingu::Text.create("#{@chant}", :y => 520, :size => 30, :color => Colors::White, :zorder => Zorder::GUI)
    @chant_text.x = 400 - @chant_text.width/2
    after(800) { @chant_text.text = "" }
    after(1200) { @chant_text.text = "#{@chant}" }
    after(2000) { @chant_text.text = "" }
    after(2400) { @chant_text.text = "#{@chant}" }
    after(3200) { push_game_state(Field) }
  end
end

#
# FIELD CHANGE GAMESTATE
#
class FieldChange < Chingu::GameState    
  trait :timer

  def setup
    self.input = { :p=>Pause, :space=>:fire, :right_shift=>:next, :left_shift=>:next, [:enter, :return] => Field }
    $window.caption = "Field Transition - Preare for Round #{$round}"

    @player1 = Player1Clone.create(:x=> $pos1_x, :y=> $pos1_y)
    @player1.input = {:holding_left=>:go_left,:holding_right=>:go_right,:holding_up=>:go_up,:holding_down=>:go_down}
    @player2 = Player2Clone.create(:x=> $pos2_x, :y=> $pos2_y)
    @player2.input = {:holding_left_ctrl=>:creep,:holding_a=>:go_left,:holding_d=>:go_right,:holding_w=>:go_up,:holding_s=>:go_down}

    @chant = "Loading Round #{$round}"

    chant
    after (1200) { @player1.go_left }
  end

  def next
    push_game_state(Field)
  end

  def fire
    puts current_game_state
  end

  def chant
    @chant_text = Chingu::Text.create("#{@chant}", :y => 520, :size => 30, :color => Color::BLACK, :zorder => Zorder::GUI)
    @chant_text.x = 400 - @chant_text.width/2
    after(800) { @chant_text.text = "" }
    after(1200) { @chant_text.text = "#{@chant}" }
    after(2000) { @chant_text.text = "" }
    after(2400) { @chant_text.text = "#{@chant}" }
    after(3200) { push_game_state(Field) }
  end

  def draw
    fill(Colors::White)
    super
  end

end
