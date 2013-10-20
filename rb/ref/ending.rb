
#
#   GAMEOVER GAMESTATE
#     simple GameOver gamestate
class GameOver < Chingu::GameState
  def initialize
    super
    self.input = { :esc => :exit, [:enter, :return] => Introduction, :p => Pause, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
  end

  def setup
    @t2 = Chingu::Text.create(:text=>"Game Over", :y=>280, :size=>28)
    @t2.x = 400 - @t2.width/2
    @t3 = Chingu::Text.create(:text=>"Press enter", :y=>380, :size=>28)
    @t3.x = 400 - @t2.width/2
    $window.caption = "Game Over"
  end

  def pop
    pop_game_state(:setup => false)
  end
end


#
#   WIN GAMESTATE
#     transition gamestate from Level_3 to Ending
class Win < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, :p => Pause, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
    $window.caption = "Victory!"
    Bullet.destroy_all   # Destroy possible lingering GameObjects
    Player.destroy_all
    Star.destroy_all
    Meteor1.destroy_all
    Meteor2.destroy_all
    Meteor3.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end

    @player = Player.create(:x => $player_x, :y => $player_y, :angle => $player_angle, :velocity_x => $player_x_vel, :velocity_y => $player_y_vel, :zorder => Zorder::Main_Character)
#   Player class is defined in objects.rb

    @accel = false       # called in update
    @turn_left = false   # called in update
    @turn_right = false  # called in update
    @firing = false      # called in update
    fly_away  # spaceship autopilot script
  end

  def fly_away
    @turn_left = true  # spaceship shifts to autopilot and flies away; push Ending gamestate
    after(500) {@turn_left = false}
    after(1000) { $music = Song["media/audio/music/end_song.ogg"]; $music.volume = 0.8; $music.play(true) }
    after(1000) { @turn_left = true }
    after(1200) { @accel = true }
    after(1300) { @player.fire } # Player methods are defined in objects.rb
    after(1350) { @player.fire }
    after(1400) { @player.fire }
    after(1400) { @accel = false }
    after(1500) { @turn_left = false }
    after(2000) { @player.accelerate }
    after(2500) { @player.accelerate }
    after(2600) { @player.turn_left }
    after(2800) { @player.accelerate }
    after(3000) { @turn_right = true }
    after(3200) { @firing = true }
    after(3600) { @player.speedify; @accel = true }
    after(3800) { @firing = false }
    after(3800) { @turn_right = false }
    after(7000) { push_game_state(Chingu::GameStates::FadeTo.new(Ending.new, :speed => 10)) }
  end

  def pop
    pop_game_state(:setup => false)
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image
    super
  end

  def update
    super
    if @turn_left == true; @player.turn_left; end     # autopilot commands
    if @turn_right == true; @player.turn_right; end
    if @accel == true; @player.accelerate; end
    if @firing == true; @player.fire; end
  end
end


#
#  ENDING GAMESTATE
#    the beginning of the end
class Ending < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => Ending2, :p => Pause, :r => lambda{current_game_state.setup} }

    @player = EndPlayer.create(:x => 400, :y => 640, :angle => 0, :velocity_x => 0, :velocity_y => 0, :zorder => Zorder::Main_Character)
    @earth = Earth1.create(:x => 400, :y => 200)
    # EndPlayer and Earth1 are defined in objects.rb
    @text = Chingu::Text.create("The Earth has been saved.", :y => 900, :font => "GeosansLight", :size => 60, :color => Colors::White, :zorder => 300)
    @text.x = 400 - @text.width/2 

    after(5000) { @player.accelerate }    # scripts affecting Earth, EndPlayer; push Ending2 gamestate
    after(10500) { @earth.motion }
    after(20000) { @earth.motion_easing }
    after(18500) { @player.shrink1}
    after(19500) { @player.shrink2; @player.adjust_particles }
    after(25700) { @player.decelerate }
    after(33000) { push_game_state(Chingu::GameStates::FadeTo.new(Ending2.new, :speed => 10)) }
  end

  def update
    super
    if @text.y >= 400            # text scrolls in at end of gamestate, tracking EndPlayer movement
      @text.y = @player.y + 330
    end
  end
end


#
#  ENDING2 GAMESTATE
#    the middle of the end
class Ending2 < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => Ending3, :p => Pause, :r => lambda{current_game_state.setup} }

    @player = EndPlayerSide.create(:x => 880, :y => 150, :angle => -90, :velocity_x => -0.7, :velocity_y => 0, :zorder => Zorder::Main_Character)
    @earth = Earth2.create(:x => 150, :y => 300)
    # EndPlayerSide and Earth2 are defined in objects.rb
    @y_change = 0.3

    after(22000) { @earth.motion_easing }
    after(26000) { Sound["media/audio/huge_crowd2.ogg"].play(0.5)}
    after(29000) { push_game_state(Ending3) }#(Chingu::GameStates::FadeTo.new(Ending3.new, :speed => 10)) }
  end

  def y_damp
    @y_change *= 0.997
  end

  def update
    super
    if @player.y <= 490         # trial and error adjustments to landing approach
      @player.y += @y_change
    end
    if @player.x <= 650
      @player.factor *= 0.998
      @player.adjust_particles
    end
    if @player.y >= 440
      y_damp
    end
    if @player.x <= 100
      @player.velocity_x *= 0.995
    end
  end
end


#
#  ENDING3 GAMESTATE
#    the end of the end - massive celebration
class Ending3 < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => EndCredits, :p => Pause, :r => lambda{current_game_state.setup} }

    @spire = Spire.create(:x => 490, :y => 80, :factor => 0.7, :zorder => 250)
    @knight = EndKnight.create(:x => 1200, :y => 505, :factor => 1.4, :zorder => 600)
    @multitude = Crowd.create(:x=>400,:y=>150) # creates a multitude in the background
    # EndKnight and Crowd are defined in characters.rb; Spire is defined in objects.rb

    @cheering1 = Sound["media/audio/huge_crowd.ogg"]
    @cheering2 = Sound["media/audio/huge_crowd_roar.ogg"]

    200.times { create_characters } # creates a multitude in the foreground

    after(50) { @cheering1.play(0.4) }    # scripts to create crowd noise
    after(6000) { @cheering2.play(0.4) }
    after(9000) { @cheering2.play(0.5) }
    after(13000) { @cheering2.play(0.6) }
    after(15500) { @cheering1.play(0.5) }
    after(16500) { @cheering2.play(0.5) }
    after(19500) { @cheering2.play(0.3) }
    after(21500) { push_game_state(Chingu::GameStates::FadeTo.new(EndCredits.new, :speed => 10)) }
  end

  def create_characters # creates 15 characters (one of each) each time it is called 
    Char1.create   # Chars are defined in characters.rb
    Char2.create
    Char3.create
    Char4.create
    Char5.create
    Char6.create
    Char7.create
    Char8.create
    Char9.create
    Char10.create
    Char11.create
    Char12.create
    Char13.create
    Char14.create
    Char15.create
  end

  def draw
    Image["../media/assets/end_background.png"].draw(0, 0, 0)    # Background Image
    super
  end
end



#
#   END CREDITS GAMESTATE
#     the end of the end of the end - big thanks to everyone who helped out!
class EndCredits < Chingu::GameState
  trait :timer
  def initialize
    super
    self.input = { :esc => :exit, [:enter, :return] => Introduction, :p => Pause, :r => lambda{current_game_state.setup}, [:q, :l] => :pop }
  end

  def setup
    $window.caption = "Credits"
    @scroll_speed = 0.6
    @st = 580  # starting y position for text
    @sp = 50   # spacing for text

    @cheering1 = Sound["media/audio/huge_crowd.ogg"]
    @cheering2 = Sound["media/audio/huge_crowd_roar.ogg"]

    # end credits start offscreen
    @t1 = Chingu::Text.create(:text=>"" , :y=>675, :size=>40, :font => "GeosansLight")
    @t1.x = 400 - @t1.width/2   # @t1 is currently blank
    @t2 = Chingu::Text.create(:text=>"Produced by Fractional and mpl" , :y=>@st+@sp*2, :size=>40, :font => "GeosansLight")
    @t2.x = 400 - @t2.width/2
    @t3 = Chingu::Text.create(:text=>"Gosu by jlnr" , :y=>@st+@sp*3, :size=>40, :font => "GeosansLight")
    @t3.x = 400 - @t3.width/2
    @t4 = Chingu::Text.create(:text=>"Chingu by ippa" , :y=>@st+@sp*4, :size=>40, :font => "GeosansLight")
    @t4.x = 400 - @t4.width/2
    @t5 = Chingu::Text.create(:text=>"Ruby by Yukihiro Matsumoto" , :y=>@st+@sp*5, :size=>40, :font => "GeosansLight")
    @t5.x = 400 - @t5.width/2
    @t6 = Chingu::Text.create(:text=>"Game Theme Music by ExplodingCookie " , :y=>@st+@sp*6, :size=>40, :font => "GeosansLight")
    @t6.x = 400 - @t6.width/2
    @t7 = Chingu::Text.create(:text=>"Intro Music from StarryKnight by burtlo" , :y=>@st+@sp*7, :size=>40, :font => "GeosansLight")
    @t7.x = 400 - @t7.width/2
    @t8 = Chingu::Text.create(:text=>"Knight and Voice from StarryKnight by burtlo" , :y=>@st+@sp*8, :size=>40, :font => "GeosansLight")
    @t8.x = 400 - @t8.width/2

    @t9 = Chingu::Text.create(:text=>"End Music needs attribution" , :y=>@st+@sp*9, :size=>40, :font => "GeosansLight")
    @t9.x = 400 - @t9.width/2
    @t10 = Chingu::Text.create(:text=>"Sound Effects need additional attribution" , :y=>@st+@sp*10, :size=>40, :font => "GeosansLight")
    @t10.x = 400 - @t10.width/2
    @t11 = Chingu::Text.create(:text=>"Future Earth by" , :y=>@st+@sp*11, :size=>40, :font => "GeosansLight")
    @t11.x = 400 - @t11.width/2
    @img11 = Signature1.create
    @img11.x = 400 + @t11.width/2 + 5 + @img11.width/2
    @img11.y = @st+@sp*11+20
    @t12 = Chingu::Text.create(:text=>"Future Earth 2 by" , :y=>@st+@sp*12, :size=>40, :font => "GeosansLight")
    @t12.x = 400 - @t12.width/2
    @img12 = Signature2.create
    @img12.x = 400 + @t12.width/2 + 10 + @img12.width/2
    @img12.y = @st+@sp*12+20
    @t13 = Chingu::Text.create(:text=>"Additional thanks to Linux/Ubuntu" , :y=>@st+@sp*13, :size=>40, :font => "GeosansLight")
    @t13.x = 400 - @t13.width/2
    @t14 = Chingu::Text.create(:text=>"Additional thanks to rvm" , :y=>@st+@sp*14, :size=>40, :font => "GeosansLight")
    @t14.x = 400 - @t14.width/2
    @t15 = Chingu::Text.create(:text=>"Additional thanks to SublimeText2" , :y=>@st+@sp*15, :size=>40, :font => "GeosansLight")
    @t15.x = 400 - @t15.width/2
    @t16 = Chingu::Text.create(:text=>"Additional thanks to Gimp" , :y=>@st+@sp*16, :size=>40, :font => "GeosansLight")
    @t16.x = 400 - @t16.width/2
    @t17 = Chingu::Text.create(:text=>"Additional thanks to gamedev.stackexchange.com" , :y=>@st+@sp*17, :size=>40, :font => "GeosansLight")
    @t17.x = 400 - @t17.width/2
    @t18 = Chingu::Text.create(:text=>"Special thanks to PeterT and Spooner" , :y=>@st+@sp*19, :size=>40, :font => "GeosansLight")
    @t18.x = 400 - @t18.width/2
    @t19 = Chingu::Text.create(:text=>"Extra Special thanks to jlnr and libgosu.org" , :y=>@st+@sp*20, :size=>40, :font => "GeosansLight")
    @t19.x = 400 - @t19.width/2
    @t20 = Chingu::Text.create(:text=>"Thanks to the people of Sweden and Honduras" , :y=>@st+@sp*26, :size=>50, :font => "GeosansLight")
    @t20.x = 400 - @t20.width/2
    @t21 = Chingu::Text.create(:text=>"Thanks to the people of Japan and Germany" , :y=>@st+@sp*27, :size=>50, :font => "GeosansLight")
    @t21.x = 400 - @t21.width/2

    after(100) { @cheering2.play(0.3) }    # scripts for crowd noise, music, and returning to Introduction gamestate
    after(2700) { @cheering2.play(0.2) }
    after(5000) { @cheering2.play(0.2) }
    after(8000) { @cheering2.play(0.1) }
    after(11000) { @cheering1.play(0.2) }
    after(11000) { $music.volume = 0.9 }
    after(14000) { $music.volume = 1.0 }

    after(45300) { push_game_state (Chingu::GameStates::FadeTo.new(Introduction.new, :speed => 10)) }
  end

  def pop
    pop_game_state(:setup => false)
  end

  def update
    @t1.y -= @scroll_speed  # move text slightly upward each tick
    @t2.y -= @scroll_speed
    @t3.y -= @scroll_speed
    @t4.y -= @scroll_speed
    @t5.y -= @scroll_speed
    @t6.y -= @scroll_speed
    @t7.y -= @scroll_speed
    @t8.y -= @scroll_speed
    @t9.y -= @scroll_speed
    @t10.y -= @scroll_speed
    @t11.y -= @scroll_speed
    @img11.y -= @scroll_speed
    @t12.y -= @scroll_speed
    @img12.y -= @scroll_speed
    @t13.y -= @scroll_speed
    @t14.y -= @scroll_speed
    @t15.y -= @scroll_speed
    @t16.y -= @scroll_speed
    @t17.y -= @scroll_speed
    @t18.y -= @scroll_speed
    @t19.y -= @scroll_speed
    if @t20.y > 650             # ease in last, final credits
      @t20.y -= @scroll_speed
      @t21.y -= @scroll_speed
    elsif @t20.y > 625
      @t20.y -= 0.4
      @t21.y -= 0.4
    elsif @t20.y > 600
      @t20.y -= 0.5
      @t21.y -= 0.5
    elsif @t20.y > 470
      @t20.y -= 0.4
      @t21.y -= 0.4
    elsif @t20.y > 462
      @t20.y -= 0.2
      @t21.y -= 0.2
    elsif @t20.y > 460
      @t20.y -= 0.1
      @t21.y -= 0.1
    end
  end
end

#               #
#     T H E     #
#               #
#     E N D     #
#               #