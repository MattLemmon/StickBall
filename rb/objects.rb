#DEBUG = false  # Set to true to see bounding circles used for collision detection
#
#
#  S T I C K  B A L L  O B J E C T S
#
#


#
# FireCube Class
#
class FireCube < Chingu::GameObject
  traits :velocity, :collision_detection
  trait :bounding_circle, :debug => DEBUG
  attr_accessor :color
  
  def initialize(options)
    super
    @mode = :additive
    
    @image = Image["objects/circle.png"]
    
    # initialize with a rightwards velocity with some damping to look more realistic
    self.velocity_x = 10
    self.velocity_y = 4
    self.factor = 2.5
    cache_bounding_circle # This does a lot for performance

    @color = Color::BLUE
    @part_speed = 10
    @die_count = 15

  end
  
  def update
    @color = Color::BLUE
    if @die_count < 15
      @die_count += 1
      @color = Color::RED
    end

    Plasma.create(:x => @x, :y => @y, :color => Color.new(0xFF0042FF))

    # Particles from rocket booster
    Chingu::Particle.create(:x => @x, :y => @y,
            :image => "objects/particle.png", 
            :color => 0xFF0096FF,
            :mode => :additive,
            :fade_rate => -45,
            :angle => @angle,
            :zorder => Zorder::Particle)
    Chingu::Particle.each { |particle| particle.y -= @velocity_y; particle.x -= @velocity_x}
    Chingu::Particle.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }

  end
  
  def die!
    @die_count = 0
#    @color = Color::RED
  end
end


#
#    Plasma Class
#
class Plasma < Chingu::GameObject
  traits :velocity
  attr_accessor :fade_rate
  
    def setup
    @image = Image["objects/particle.png"]
    @mode = :additive
    # initialize with a rightwards velocity with some damping to look more realistic
 #   @velocity_x = options[:velocity_x] || 10
 #   @acceleration_x = -0.1
    
    # Simulate gravity
#    @acceleration_y = 0.4
    @fade_rate = 6
  end

  def update
    self.alpha -= @fade_rate  if defined?(@fade_rate)
  end
end




#
#   BULLET
#     technically speaking, it's a laser, but it's still called "Bullet"
class Bullet < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  has_traits :timer, :velocity, :collision_detection

  def initialize(options)
    super(options.merge(:image => Gosu::Image["objects/laser.png"]))
    @speed = 7
    self.velocity_x = Gosu::offset_x(@angle, @speed)
    self.velocity_y = Gosu::offset_y(@angle, @speed)
    @max_x, @max_y, @scr_edge = $max_x, $max_y, $scr_edge
  end

  def update
    @y += self.velocity_y
    @x += self.velocity_x
    if @x < -@scr_edge; @x = @max_x; end  # wrap beyond screen edge
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
    after(550) {self.destroy}  # goes through screen edges, but only to a certain distance
  end
end




#
#   EXPLOSION
#     called in levels.rb when meteors are destroyed and when player dies
class Explosion < Chingu::GameObject
  trait :timer
  def setup
    @animation = Chingu::Animation.new(:file => "objects/explosion.png", :delay => 5)
  end
  def update
    @image = @animation.next
    after(100) {self.destroy}
  end
end


#
#   STAR CLASS
#     stars can be picked up by player; called in levels.rb
class Star < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  trait :collision_detection
  
  def setup
    @animation = Chingu::Animation.new(:file => "objects/living.png", :size => 64)
    @image = @animation.next
    self.zorder = 200
    self.color = Gosu::Color.new(0xff000000)
    self.color.red = rand(255 - 40) + 40
    self.color.green = rand(255 - 40) + 40
    self.color.blue = rand(255 - 40) + 40
    self.x = rand * 800
    self.y = rand * 600
    cache_bounding_circle     # A cached bounding circle will not adapt to changes in size, but it will follow objects X / Y
  end
  
  def update
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation.next
  end
end



#
#  SPARKLE
#    called in OpeningCredits2 gamestate (Ruby logo)
class Sparkle < Chingu::GameObject
  def setup
    @image = Image["objects/sparkle.png"]
    self.factor = 0.1
    @turning = 0.5
    @factoring = 1.0
    @angle = 35
  end

  def turnify1; @turning = 0.6; @factoring = 1.2;   end
  def turnify2; @turning = 0.55; @factoring = 1.025;  end
  def turnify3; @turning = 0.45; @factoring = 1.015;  end
  def turnify4; @turning = 0.3; @factoring = 1.002;  end
  def turnify5; @turning = 0.15; @factoring = 1.0005;  end
  def turnify6; @turning = 0.0; @factoring = 1.0;  end

  def update
    @angle += @turning
    self.factor *= @factoring
    if self.factor >= 1.1
      @factoring = 1.0
    end
  end
end



#
#  HIGHLIGHT
#    called in OpeningCredits gamestate (Gosu logo)
class Highlight < Chingu::GameObject
  def setup
    @image = Image["objects/highlight.png"]
  end
  def update
    @x += 5
  end
end

#
#  HIGHLIGHT2
#    called in OpeningCredits gamestate (Gosu logo)
class Highlight2 < Chingu::GameObject
  def setup
    @image = Image["objects/highlight2.png"]
  end
  def update
    @x += 5
  end
end

