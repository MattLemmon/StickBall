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

    $music.volume = 0.0
    loading
    after (1200) { chant }
#    after (1200) { @player1.go_left }
  end

  def loading
    if $round == 1
      after(400) {$hold_music1.play(0.5)}
      $speed1 = 6
      $speed2 = 6
      $score1 = 0
      $score2 = 0
    end
    if $round == 2
      after(400) {$hold_music3.play(0.5)}
    end
    if $round == 3
      after(400) {$hold_music4.play(0.5)}
    end
  end


  def next
    push_game_state(Field)
  end

  def fire
    puts current_game_state
  end

  def chant
    @chant_text = Chingu::Text.create("#{@chant}", :y => 300, :size => 40, :color => Color::BLACK, :zorder => Zorder::GUI)
    @chant_text.x = 400 - @chant_text.width/2
    after(400) { @chant_text.text = "" }
    after(1000) { @chant_text.text = "#{@chant}" }
    after(1600) { @chant_text.text = "" }
    after(2200) { @chant_text.text = "#{@chant}" }
    after(1800) { @chant_text.text = "" }
    after(3400) { @chant_text.text = "#{@chant}" }
    after(4000) { @chant_text.text = "" }
    after(4600) { @chant_text.text = "#{@chant}" }
    after(4000) { @chant_text.text = "" }
    after(4600) { @chant_text.text = "#{@chant}" }
    after(5400) { push_game_state(Field) }
  end

  def update
    $pos1_x, $pos1_y = @player1.x, @player1.y
    $pos2_x, $pos2_y = @player2.x, @player2.y
    super
  end

  def draw
    fill(Colors::White)
    super
  end

end
