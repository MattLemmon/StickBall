#  Core.rb  -  Classes: Loader, Welcome, Pause

#
#  LOADER WINDOW CLASS
#
class Loader < Chingu::Window
  def initialize
    super(900,700)
    @cursor = true # comment out to hide cursor
    self.input = { :esc => :exit,
                   [:l, :q, :f7] => :pop,
                   [:enter, :return, :f8] => :next,
                   :z => :log,
                   :f => :flat,
                   :f7 => :pop,
                   :f8 => :next,
                   :r => lambda{current_game_state.setup}
                 }
    @nextgame = [ DroidGame, Bowl, Pond, Plasmoids, Jungle, Splash, Cat, Zoom, CityBattle, Sandbox,
                  GameOfLife, ParticleDisplay, FillGrdnt, FillGrdntMultClrs, Fill ]
    @w = true
    @ng = -1
  end

  def setup
    retrofy
    push_game_state(Bowl)
  end

  def log
    puts $window.current_game_state
  end

  def next
    if @ng == 13
      @ng = 0
    else
        @ng += 1
    end
    push_game_state(@nextgame[@ng])
  end

  def pop
    if $window.current_game_state.to_s != "Pause" && $window.current_game_state.to_s != "GameOver" then
      if @ng == 0
        @ng = 13
      else
        @ng -= 1
      end
    end
    if $window.current_game_state.to_s != "Welcome" then
      pop_game_state(:setup => false)
    end
    if $window.current_game_state.to_s == "Welcome" then
      @ng = -1
    end
  end

  def flat
    Flat.create
  end
end

#
#  PAUSE GAMESTATE
#
class Pause < Chingu::GameState
  def initialize(options = {})
    super
    @title = Chingu::Text.create(:text=>"PAUSED (press 'P' to un-pause, 'R' to reset)", :x=>100, :y=>100, :size=>30, :color => Color.new(0xFF00FF00), :zorder=>1000 )
    self.input = { :p => :un_pause, :r => :reset }
  end
  def un_pause
    pop_game_state(:setup => false)    # Return the previous game state, dont call setup()
  end  
  def reset
    pop_game_state(:setup => true)
  end
  def draw
    previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
    super                       # Draw game objects in current game state, this includes Chingu::Texts
  end  
end

#
#   WELCOME SCREEN GAMESTATE
#
class Welcome < Chingu::GameState
  def initialize
    super
    self.input = { :holding_space => :new_fire_cube,
                   :left => :decrease_speed,
                   :right => :increase_speed,
                   :up => :increase_size,
                   :down => :decrease_size,
                   :p => Pause    }

    #@t00 = Chingu::Text.create(:text=>"loader" ,         :x=>344, :y=>130, :size=>44)
#    @t01 = Chingu::Text.create(:text=>"local controls" ,     :x=>100, :y=>230, :size=>28)
    @t02 = Chingu::Text.create(:text=>"    spacebar" ,       :x=>266, :y=>180, :size=>28)
    @t03 = Chingu::Text.create(:text=>"   arrow keys" ,      :x=>266, :y=>220, :size=>28)
    @t04 = Chingu::Text.create(:text=>"enter       -         next gamestate" ,       :x=>308, :y=>260, :size=>28)
    @t05 = Chingu::Text.create(:text=>"P           -         pause  " ,              :x=>324, :y=>300, :size=>28) 
    @t06 = Chingu::Text.create(:text=>"R           -         reset  " ,              :x=>323, :y=>340, :size=>28)
    @t07 = Chingu::Text.create(:text=>"Z           -         status log" ,           :x=>324, :y=>380, :size=>28)
    @t08 = Chingu::Text.create(:text=>"Q  or  L      -         last gamestate" ,   :x=>295, :y=>420, :size=>28)
    @t09 = Chingu::Text.create(:text=>"esc         -         exit" ,                 :x=>314, :y=>460, :size=>28)
#    @t10 = Chingu::Text.create(:text=>"global controls" ,    :x=>100, :y=>390, :size=>28)
  end

  def setup
    FireCube.destroy_all
    $window.caption = "chingu gamestate loader"
  end

  def new_fire_cube
    FireCube.create(:x => rand($window.width - 400), :y => rand($window.height - 300))
  end
  def increase_size
    FireCube.each { |go| go.factor += 1 }
  end
  def decrease_size
    FireCube.each { |go| go.factor -= 1 if go.factor > 1  }
  end
  def increase_speed
    FireCube.each { |go| go.velocity_x *= 4; go.velocity_y *= 4; }
  end
  def decrease_speed
    FireCube.each { |go| go.velocity_x *= 0.25; go.velocity_y *= 0.25; }
  end
end
