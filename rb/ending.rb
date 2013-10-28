
#
#   GAMEOVER GAMESTATE
#     simple GameOver gamestate
class GameOver < Chingu::GameState
  def initialize
    super
    self.input = { :esc => :exit, [:enter, :return] => PreIntro, :p => Pause, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
  end

  def setup
    @text1 = Chingu::Text.create(:text=>"#{$winner} wins!", :y=>280, :size=>28)
    @text1.x = 400 - @text1.width/2


#    @t2 = Chingu::Text.create(:text=>"Game Over", :y=>280, :size=>28)
#    @t2.x = 400 - @t2.width/2
    @t3 = Chingu::Text.create(:text=>"Press enter", :y=>380, :size=>28)
    @t3.x = 400 - @t3.width/2
    $window.caption = "Game Over"
  end

  def pop
    pop_game_state(:setup => false)
  end
end


#
#   ENDING 1 GAMESTATE
#
class Ending1 < Chingu::GameState
  trait :timer
  def setup
    self.input = { [:left_ctrl, :left_shift, :right_ctrl, :right_shift] => Intro, :esc => :exit, :p => Pause, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
    $window.caption = "Victory!"
    Player1.destroy_all
    Player2.destroy_all
    Star.destroy_all
    FireCube.destroy_all
    if @player1 != nil; @player1.destroy; end
    if @player2 != nil; @player2.destroy; end

#    @player = Player.create(:x => $player_x, :y => $player_y, :angle => $player_angle, :velocity_x => $player_x_vel, :velocity_y => $player_y_vel, :zorder => Zorder::Main_Character)
    transition
  end

  def transition
    after(3000) { push_game_state(Chingu::GameStates::FadeTo.new(PreIntro.new, :speed => 10)) }
  end

  def pop
    pop_game_state(:setup => false)
  end

  def draw
#    Image["objects/background.png"].draw(0, 0, 0)    # Background Image
    super
  end

  def update
    super
  end
end


#               #
#     T H E     #
#               #
#     E N D     #
#               #