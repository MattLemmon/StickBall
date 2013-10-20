DEBUG = false  # Set to true to see bounding circles used for collision detection

#
#  PLAYER CLASS
#    called in levels.rb and in ending.rb (Win gamestate)
class Player < Chingu::GameObject
	attr_reader :health, :score
  trait :bounding_circle, :debug => DEBUG
	traits :velocity, :collision_detection
	def initialize(health)
		super
    @picture1 = Gosu::Image["assets/player.png"]
    @picture2 = Gosu::Image["assets/player_blink.png"]
		@width, @height = 32, 32
		@max_speed, @speed, @part_speed, @rotate_speed = 10, 0.4, 7, 5

    @shoot = Sound["media/audio/laser.OGG"]
    @max_x = $max_x
  	@max_y = $max_y
  	@scr_edge = $scr_edge
    @cooling_down = 0
    @blink = 14
	end

  def cool_down   # player cannot be damaged when blinking
    @cooling_down = $cooling_down
  end

  def damage
    if @cooling_down == 0  # only causes damage is player is not blinking
      @cooling_down = $cooling_down
      $health -= 1
      Sound["media/audio/exploded.ogg"].play(0.3)
    end
  end

  def blink    # blink on and off every 7 ticks
    if @blink == 14
      @image = @picture2
      @blink = 0
    elsif @blink == 7
      @image = @picture1
      @blink +=1
    else
      @blink +=1
    end
  end

	def accelerate  # pressing up arrow causes player to accelerate
    if self.velocity_x <= @max_speed && self.velocity_y <= @max_speed
  		self.velocity_x += Gosu::offset_x(self.angle, @speed)
	  	self.velocity_y += Gosu::offset_y(self.angle, @speed)
    end
	end

	def brake       # pressing down arrow invokes brakes
		self.velocity_x *= 0.88
		self.velocity_y *= 0.88
	end

	def turn_left
		self.angle -= @rotate_speed
	end

	def turn_right
		self.angle += @rotate_speed
	end

  def fire
		@shoot.play(rand(0.05..0.1))  # randomize laser sound effect volume
    if $weapon == 1   # number of Bullets fired depends on weapons upgrade status
  		Bullet.create(:x => @x, :y => @y, :angle => @angle, :zorder => Zorder::Projectile)

    elsif $weapon == 2   # use Gosu::offset for upgraded weapons (thanks to PeterT)
      Bullet.create(:x => @x + Gosu::offset_x(@angle+90, 8), :y => @y + Gosu::offset_y(@angle+90, 8), :angle => @angle)
      Bullet.create(:x => @x + Gosu::offset_x(@angle+90, -8), :y => @y + Gosu::offset_y(@angle+90, -8), :angle => @angle)

    elsif $weapon >= 3   # fires three Bullets when weapons are fully upgraded
      Bullet.create(:x => @x, :y => @y, :angle => @angle, :zorder => Zorder::Projectile)
      Bullet.create(:x => @x + Gosu::offset_x(@angle+90, 14), :y => @y + Gosu::offset_y(@angle+90, 14), :angle => @angle)
      Bullet.create(:x => @x + Gosu::offset_x(@angle+90, -14), :y => @y + Gosu::offset_y(@angle+90, -14), :angle => @angle)
#      Bullet.create(:x => @x + 20 * Math.cos(@angle*Math::PI/180) , :y => @y + 20 * Math.sin(@angle*Math::PI/180), :angle => @angle)
#      alternate way to do the weapons offsets with sin and cos
    end
  end

  def speedify  # method called in Win gamestate, in ending.rb
    @max_speed = 50
  end

  def update
    self.velocity_x *= 0.99   # dampen velocity
    self.velocity_y *= 0.99

    if @cooling_down != 0  # player cannot be damaged during cool down
      @cooling_down -= 1   # cool down counter
      blink  # calls blink method -- player blinks when @cooling_down is not 0
    else
      @image = @picture1
    end

    if @x < -@scr_edge; @x = @max_x; end  # wrap around beyond screen edges
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end

    # Particles from rocket booster
		Chingu::Particle.create(:x => @x, :y => @y,
	  				:image => "assets/particle_1.png", 
						:color => 0xFF86EFFF, 
						:mode => :default,
						:fade_rate => -45,
						:angle => @angle,
						:zorder => Zorder::Main_Character_Particles)
		Chingu::Particle.each { |particle| particle.y -= Gosu::offset_y(@angle, @part_speed); particle.x -= Gosu::offset_x(@angle, @part_speed)}
		Chingu::Particle.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
  end
end


#
#   EXPLOSION
#     called in levels.rb when meteors are destroyed and when player dies
class Explosion < Chingu::GameObject
  trait :timer
  def setup
    @animation = Chingu::Animation.new(:file => "media/assets/explosion.png", :delay => 5)
  end
  def update
    @image = @animation.next
    after(100) {self.destroy}
  end
end


#
#   BULLET
#     technically speaking, it's a laser, but it's still called "Bullet"
class Bullet < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  has_traits :timer, :velocity, :collision_detection

  def initialize(options)
    super(options.merge(:image => Gosu::Image["assets/laser.png"]))
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
#   STAR CLASS
#     stars can be picked up by player; called in levels.rb
class Star < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  trait :collision_detection
  
  def setup
    @animation = Chingu::Animation.new(:file => "../media/assets/living.png", :size => 64)
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
#   METEOR
#     Meteor class is used in Introduction gamestate
class Meteor < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

	def initialize(options)
		super(options.merge(:image => Gosu::Image["assets/meteor.png"]))
		@angular_velocity = 5
		@random = rand(2)+1
		if(@random == 1)
			@angular_velocity = -@angular_velocity
		end
	end

	def update
		@angle += @angular_velocity
	end
end

#
#   METEOR 1 - BIG
#     Meteor1 class is used in levels.rb
class Meteor1 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["media/assets/meteor.png"]
    self.factor = 1.52  # meteor size
    self.zorder = 500
    self.velocity_x = (3 - rand * 6) * 2  # randomize location
    self.velocity_y = (3 - rand * 6) * 2
    @angle = rand(360)                    # randomize rotation
    @rotate = rand(10) + 5
    if @rotate == 0; @rotate = 6; end
    if rand(2) == 1; @rotate *= -1; end
    @max_x, @max_y, @scr_edge = $max_x, $max_y, $scr_edge
    cache_bounding_circle   # cache meteor size for collision detection
  end

#  def meteor_placement
#    if rand(2) == 1
#      self.x = 0
#      self.y = rand(600)
#    else
#      self.x = rand(800)
#      self.y = 0
#    end
#  end

  def update
    @angle += @rotate
    if @x < -@scr_edge; @x = @max_x; end  # wrap around screen beyond edges
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
  end
end

#
#   METEOR 2 - MEDIUM
#     Meteor2 class is used in levels.rb
class Meteor2 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["media/assets/meteor.png"]
    self.zorder = 500
    self.factor = 1.16  # meteor size
    self.velocity_x = (3 - rand * 6) * 2  # randomize location
    self.velocity_y = (3 - rand * 6) * 2
    @angle = rand(360)                    # randomize rotation
    @rotate = 5 - rand(10)
    if @rotate == 0; @rotate = 6; end
    if rand(2) == 1; @rotate *= -1; end
    @max_x, @max_y, @scr_edge = $max_x, $max_y, $scr_edge
    cache_bounding_circle    # cache meteor size for collision detection
  end

  def update
    @angle += @rotate
    if @x < -@scr_edge; @x = @max_x; end  # wrap around screen beyond edges
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
  end
end

#
#   METEOR 3 - SMALL
#     Meteor3 class is used in levels.rb
class Meteor3 < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection

  def setup
    @image = Image["media/assets/meteor.png"]
    self.zorder = 500
    self.factor = 0.78  # meteor size
    self.velocity_x = (3 - rand * 6) * 2.5  # randomize location
    self.velocity_y = (3 - rand * 6) * 2.5
    @angle = rand(360)                      # randomize rotation
    @rotate = 5 - rand(10)
    if @rotate == 0; @rotate = 6; end
    if rand(2) == 1; @rotate *= -1; end
    @max_x, @max_y, @scr_edge = $max_x, $max_y, $scr_edge
    cache_bounding_circle   # cache meteor size for collision detection
  end

  def update
    @angle += @rotate
    if @x < -@scr_edge; @x = @max_x; end  # wrap around screen beyond edges
    if @y < -@scr_edge; @y = @max_y; end
    if @x > @max_x; @x = -@scr_edge; end
    if @y > @max_y; @y = -@scr_edge; end
  end
end

#
#  SPARKLE
#    called in OpeningCredits2 gamestate (Ruby logo)
class Sparkle < Chingu::GameObject
  def setup
    @image = Image["media/assets/sparkle.png"]
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
    @image = Image["media/assets/highlight.png"]
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
    @image = Image["media/assets/highlight2.png"]
  end
  def update
    @x += 5
  end
end

#
#  EARTH 1
#    called in Ending gamestate - trial and error adjustments to slowly zoom into view
class Earth1 < Chingu::GameObject
  def setup
    @image = Image["media/assets/future_earth.png"]
    self.factor = 0.002
    @factoring = 1.0045
    @motion = 0.0
    @easing = 1.0
    @fact_ease = 0.999975
  end
  def fact_ease
    @fact_ease = 0.998
  end
  def motion
    @motion = 0.08
  end
  def motion_easing
    @easing = 0.998
  end
  def update
    @y += @motion
    @motion *= @easing
    self.factor *= @factoring
    if self.factor >= 0.21
      @factoring *= @fact_ease
    end
    if self.factor >= 0.3142
      @factoring = 1.0
    end
  end
end


#
#  EARTH 2
#    used in Ending2 gamestate
class Earth2 < Chingu::GameObject
  def setup
    @image = Image["media/assets/future_earth2.png"]
    self.factor = 1.2
    @motion = 0.34
    @easing = 1.0
  end
  def motion_easing  # method called in Ending2 gamestate
    @easing = 0.994
  end
  def update
    @x += @motion
    @motion *= @easing
  end
end


#
#  END PLAYER
#    Player clone with no blinking, used in Introduction and Ending gamestates
#    Adds in some methods to adjust the spaceship size and movement as it descends to Earth
class EndPlayer < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection
  def setup
    @image = Gosu::Image["assets/player.png"]
    @width, @height = 32, 32
    @speed = 0.34
    @max_speed, @part_speed, @rotate_speed = 10, 8, 5
    @shoot = Sound["media/audio/laser.OGG"]
    @easing = 1.0          # amount to slow down EndPlayer each tick
    @shrinkage = 1.0       # amount to scale image each tick
    @particles_slow = 1.0  # amount to adjust particle particle speed
    self.factor = 1.0
  end

  def shrink1   # method called in Ending gamestate
    @shrinkage = 0.998
  end
  
  def shrink2   # method called in Ending gamestate
    @shrinkage = 0.996
  end

  def accelerate
    if self.velocity_x <= @max_speed && self.velocity_y <= @max_speed
      self.velocity_x += Gosu::offset_x(self.angle, @speed)
      self.velocity_y += Gosu::offset_y(self.angle, @speed)
    end
  end

  def decelerate
    @easing = 0.99
  end

  def adjust_particles
    @particles_slow = 0.997
  end

  def update
    self.factor *= @shrinkage
    @part_speed *= @particles_slow
    self.velocity_x *= @easing
    self.velocity_y *= @easing

     Chingu::Particle.create(:x => @x, :y => @y,
            :image => "assets/particle_1.png", 
            :color => 0xFF86EFFF, 
            :mode => :default,
            :fade_rate => -45,
            :angle => @angle,
            :factor => @factor,
            :zorder => Zorder::Main_Character_Particles)

     Chingu::Particle.each { |particle| particle.y -= Gosu::offset_y(@angle, @part_speed); particle.x -= Gosu::offset_x(@angle, @part_speed)}
     Chingu::Particle.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
  end
end

#
#  END PLAYER SIDE
#    used in Ending 2 gamestate
class EndPlayerSide < Chingu::GameObject
#  attr_reader :health, :score
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection
  def setup
    @image = Gosu::Image["assets/player_side.png"]
    @width, @height = 32, 32
    @max_speed, @speed, @part_speed = 10, 0.4, 6
#    @blink = 14
    @easing = 1.0           # define variables relating to scaling and movement
    @shrinkage = 1.0
    @particles_slow = 1.0
    @part_fact = 0.4
    @part_offset = 15
    @part_off_change = 1.0
    self.factor = 1.5
  end

  def adjust_particles
    @particles_slow = 0.999
    @part_off_change *= 0.99999
  end

  def update
    self.factor *= @shrinkage

    @part_speed *= @particles_slow
    @part_offset *= @part_off_change

    self.velocity_x *= @easing
    self.velocity_y *= @easing

      Chingu::Particle.create(:x => @x + @part_offset, :y => @y,
            :image => "assets/particle_1.png", 
            :color => 0xFF86EFFF, 
            :mode => :default,
            :fade_rate => -25,
            :angle => @angle,
            :factor => @factor * @part_fact,
            :zorder => Zorder::Main_Character_Particles)

      Chingu::Particle.each { |particle| particle.y -= Gosu::offset_y(@angle, @part_speed); particle.x -= Gosu::offset_x(@angle, @part_speed)}
      Chingu::Particle.destroy_if { |object| object.outside_window? || object.color.alpha == 0 }
  end
end

#
#  SPIRE
#    used in Ending3 gamestate
class Spire < Chingu::GameObject
  def setup
    @image = Gosu::Image["assets/spire.png"]
  end
end

#
#  SIGNATURE 1
#    used in EndCredits gamestate
class Signature1 < Chingu::GameObject
  def setup
    @image = Image["media/assets/fut_earth_sig.png"]
    self.factor = 0.9
  end
end

#
#  SIGNATURE 2
#    used in EndCredits gamestate
class Signature2 < Chingu::GameObject
  def setup
    @image = Image["media/assets/fut_earth2_sig.png"]
    self.factor = 1.4
  end
end

