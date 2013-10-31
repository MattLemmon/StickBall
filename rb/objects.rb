#
#
#  S T I C K  B A L L  O B J E C T S
#
#


#
# FireCube   (the puck / ball)
#
class FireCube < Chingu::GameObject
  traits :velocity, :collision_detection
  trait :bounding_circle, :debug => DEBUG
  attr_accessor :color
  
  def initialize(options)
    super
    @mode = :additive
    @x = 250 + rand(300)
    @y = 100 + rand(400)
    @image = Image["objects/circle.png"]
    self.velocity_x = 10; if rand(2) == 1; self.velocity_x = -10; end
    self.velocity_y = 4; if rand(2) == 1; self.velocity_y = -4; end
    self.factor = 2.5
    @color = Color::BLUE
    @die_count = 15
    cache_bounding_circle # This does a lot for performance
  end
  def update
    @color = Color::BLUE
    if @die_count < 15
      @die_count += 1
      @color = Color::RED
    end
    Plasma.create(:x => @x, :y => @y, :color => Color.new(0xFF0042FF))
  end
  def die!
    @die_count = 0
  end
end


#
#    PLASMA
#
class Plasma < Chingu::GameObject
  traits :velocity
  attr_accessor :fade_rate
  def setup
    @image = Image["objects/particle.png"]
    @mode = :additive
    @fade_rate = 6
  end
  def update
    self.alpha -= @fade_rate  if defined?(@fade_rate)
  end
end

#
#   PARTICULATE
#
class Particulate < Chingu::Particle
  traits :velocity
end

#
#   STAR
#                                used for power_ups
class Star < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection
  attr_accessor :color
  def setup
    @animation = Chingu::Animation.new(:file => "objects/living.png", :size => 64)
    @image = @animation.next
    self.zorder = 200
    self.color = Gosu::Color.from_hsv(rand(360), 1, 1)
    self.factor = 0.65
    cache_bounding_circle     # A cached bounding circle will not adapt to changes in size, but it will follow objects X / Y
  end
  def update                    # Move the animation forward by fetching the next frame and putting it into @image
    @image = @animation.next    # @image is drawn by default by GameObject#draw
    self.velocity_x *= 0.95
    self.velocity_y *= 0.95
    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
  end
end

#
#   HEART
#
class Heart < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection
  def setup
    @image = Image["gui/heart.png"]
    cache_bounding_circle
    @counter = 0
    @count = 1
    @count_tot = 13
    @factorizer = 0.05
    self.factor = 1.4
  end
  def update
    @counter += @count
    if @counter == @count_tot
      @factorizer *= -1
      @count = -1
    end
    if @counter == -@count_tot
      @factorizer *= -1
      @count = 1
    end
    self.factor -= @factorizer
    self.velocity_x *= 0.91
    self.velocity_y *= 0.91
    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
  end
end

#
#   STUN
#
class Stun < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["objects/stun.png"]
    @counter = 0
    @count = 1
    @count_tot = 13
    @factorizer = 0.025
    self.factor = 0.6
    cache_bounding_circle
  end

  def update
    @counter += @count
    if @counter == @count_tot
      @factorizer *= -1
      @count = -1
    end
    if @counter == -@count_tot
      @factorizer *= -1
      @count = 1
    end

    self.factor -= @factorizer
    self.velocity_x *= 0.93
    self.velocity_y *= 0.93
    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
  end
end

#
#   MIST
#
class Mist < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["objects/mist.png"]
    @counter = 0
    @count = 1
    @count_tot = 13
    @factorizer = 0.025
    self.factor = 0.6
    cache_bounding_circle
  end

  def update
    @counter += @count
    if @counter == @count_tot
      @factorizer *= -1
      @count = -1
    end
    if @counter == -@count_tot
      @factorizer *= -1
      @count = 1
    end

    self.factor -= @factorizer
    self.velocity_x *= 0.94
    self.velocity_y *= 0.94
    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
  end
end

#
#  SPELL 1
#                thrown at opponent when spell is cast
class Spell1 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection
  attr_accessor :color
  attr_reader :spell_type

  def setup
    @spell_type = $spell1
    @mode = :default
    @animation = Chingu::Animation.new(:file => "objects/living.png", :size => 64)
    @image = @animation.next
    self.zorder = 200
    self.color = Gosu::Color.from_hsv(rand(360), 1, 1)
    self.factor = 0.95
    @x = @x - 5 + rand(10)
    @y = @y - 5 + rand(10)
    cache_bounding_circle     # A cached bounding circle will not adapt to changes in size, but it will follow objects X / Y
  end
  def update
    @image = @animation.next
    self.velocity_x *= 0.97
    if self.x < -300
      self.destroy
    end 
    if self.x > 1100
      self.destroy
    end 
  end
end

#
#  SPELL 2
#                thrown at opponent when spell is cast
class Spell2 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection
  attr_accessor :color
  attr_reader :spell_type

  def setup
    @spell_type = $spell2
    @animation = Chingu::Animation.new(:file => "objects/living.png", :size => 64)
    @image = @animation.next
    self.zorder = 200
    self.color = Gosu::Color.from_hsv(rand(360), 1, 1)
    self.factor = 0.95
    cache_bounding_circle     # A cached bounding circle will not adapt to changes in size, but it will follow objects X / Y
  end
  def update
    @image = @animation.next
    self.velocity_x *= 0.97
#    self.velocity_y *= 0.95
    if self.x < -300
      self.destroy
    end 
    if self.x > 1100
      self.destroy
    end 
  end
end


#
#  ZAPPER
#                 lightning bolt .bmp thanks to WanderingWeezard
class Zapper < Chingu::GameObject
  trait :timer
  def setup
    @animation = Chingu::Animation.new(:file => "objects/lightning.bmp")
#    @animation = Gosu::Image.load_tiles($window, "objects/lightning.bmp", 95, 112, false)
    self.zorder = 500
#    self.factor = 0.65
  end
  def update
    @image = @animation.next  # move animation forward
    after(3000) {self.destroy}
  end
end

#
#  SMOG
#                 lightning bolt .bmp thanks to WanderingWeezard
class Smog < Chingu::GameObject
  trait :timer
  def setup
    @image = Image["objects/smog.png"]
    self.zorder = 500
    self.factor = 2.0 + rand(10.0) / 10
  end
  def update
    after(200) {self.destroy}
  end
end


#
#  TITLE
#
class Title < Chingu::GameObject
  def setup
    @image = Image["objects/title.png"]
    @y = 180
    @zorder = 20
    @x = 400
  end
end

#
#  SPARKLE
#
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



#
#   EXPLOSION
# 
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



