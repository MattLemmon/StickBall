# Classes: Plasma, Plasmoids
# from Chingu Tutorial Demonstrating traits "velocity" and "effect"

#
#    Plasma Class
#
class Plasma < Chingu::GameObject
  traits :velocity
  attr_accessor :fade_rate
  
    def setup
    @image = Image["../media/particle.png"]
    @mode = :additive
    # initialize with a rightwards velocity with some damping to look more realistic
    @velocity_x = options[:velocity_x] || 10
    @acceleration_x = -0.1
    
    # Simulate gravity
    @acceleration_y = 0.4
  end

  def update
    self.alpha -= @fade_rate  if defined?(@fade_rate)
  end
end

#
#  PLASMOIDS GAMESTATE
#
class Plasmoids < Chingu::GameState
  def setup
    Plasma.destroy_all
    @color1 = Color.new(0xFFFFEA02)
    @color2 = Color.new(0xFF078B20)
    @color3 = Color.new(0xFF31B02B)
    self.input = {:holding_left => :decrease_speed, :holding_right => :increase_speed, :up => :increase_size, :down => :decrease_size, :holding_space => :fire, :p => Pause, :r => lambda{ current_game_state.setup } }
#    self.input = { :space => :fire }
    #
    # +1 fps
    #
    #@ground_y = $window.height * 0.95
    @ground_y = ($window.height * 0.95).to_i
    @count_a = 10
    @count_b = 10000
  end
  
  def increase_size
    game_objects.each { |go| go.factor += 1 }
  end
  def decrease_size
    game_objects.each { |go| go.factor -= 1 if go.factor > 1  }
  end
  def increase_speed
    if @count_a >= 10
      game_objects.each { |go| go.velocity_x *= 2; go.velocity_y *= 2; }
      @count_a = 1
    else
      @count_a += 1
    end
  end
  def decrease_speed
    if @count_b >= 10000
      game_objects.each { |go| go.velocity_x *= 0.5; go.velocity_y *= 0.5; }
      @count_b = 1
    else
      @count_b += 1
    end
    game_objects.each { |go| go.velocity_x *= 0.5; go.velocity_y *= 0.5; }
  end

  def fire
    Plasma.create(:x => 180 + rand(100), :y => 0 + rand(10), :color => Color.new(0xFF00FF00), :velocity_x => 10 + rand(5))
  end

  def update
    
    #
    # old velocity.rb 350 particles, 49 fps
    # first optimization: 490 particles, 47 fps (350 @ 60)
    # optimized GameObject if/elsif: 490 particles, 50 fps
    #
    Plasma.create(:x => 0, :y => 200 + rand(5), :color => Color::RED.dup, :velocity_x => 10)
    Plasma.create(:x => 0, :y => 250 + rand(5), :color => Color.new(0xFF86EFFF), :velocity_x => 14)
    Plasma.create(:x => 0, :y => 300 + rand(5), :color => Color.new(0xFF86EFFF), :velocity_x => 7)
    Plasma.create(:x => 0, :y => 400 + rand(5), :color => Color.new(0xFF86EFFF), :velocity_x => 6)
        
    Plasma.each do |particle|
      #
      # +1 fps
      #
      # particle.x += 1 - rand(2)
      # -just removed, not replaced-
            
      #
      # If particle hits the ground:
      #
      if particle.y >= @ground_y
        
        # 1) "Bounce" it up particle by reversing velocity_y with damping
        slower = particle.velocity_y/3
        particle.velocity_y = -(slower + rand(slower))
        
        # 2) "Bounce" it randomly to left and right
        if rand(2) == 0
          particle.velocity_x = particle.velocity_y/2 + rand(2)     # Randomr.randomr / 50
          particle.acceleration_x = -0.02
        else
          particle.velocity_x = -particle.velocity_y/2 - rand(2)    # Randomr.randomr / 50
          particle.acceleration_x = 0.02
        end
        
        # 3) Start fading the alphachannel
        particle.fade_rate = 3        
      end
    end
    
    #
    # +4 fps
    #
    #self.game_objects.reject! { |object| object.outside_window? || object.color.alpha == 0 }
    self.game_objects.destroy_if { |object| object.color.alpha == 0 }
    
    super
  end
  
  def draw
    $window.caption = "particle example (esc to quit) [particles#: #{game_objects.size} - framerate: #{$window.fps}]"
    fill_gradient(:from => Color.new(255,0,0,0), :to => Color.new(255,60,60,80), :rect => [0,0,$window.width,@ground_y])
    fill_gradient(:from => Color.new(255,100,100,100), :to => Color.new(255,50,50,50), :rect => [0,@ground_y,$window.width,$window.height-@ground_y])
    super
  end
end

