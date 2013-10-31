
#
#   GAMEOVER GAMESTATE
# 
class GameOver < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:left_shift, :right_shift] => PreIntro, :p => Pause } #, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
    $window.caption = "StickBall - Game Over"

    @text1 = Chingu::Text.create(:text=>"#{$winner} Wins!", :y=>280, :size=>28)
    @text1.x = 400 - @text1.width/2

#    @t2 = Chingu::Text.create(:text=>"Game Over", :y=>280, :size=>28)
#    @t2.x = 400 - @t2.width/2
    @t3 = Chingu::Text.create(:text=>"press shift", :y=>380, :size=>28)
    @t3.x = 400 - @t3.width/2

    $music.volume = 0.0
    after(300) { $game_over.play(0.8) }
    after(10000) { push_game_state(PreIntro) } #Chingu::GameStates::FadeTo.new(PreIntro.new, :speed => 10)) }
  end

end



#               #
#     T H E     #
#               #
#     E N D     #
#               #