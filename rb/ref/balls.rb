# Classes: Bowl, FireCube, Splash, Circle, Box
# GAMESTATES:  BOWL,  SPLASH

#
# BOWL GAMESTATE
#
# from Chingu Tutorial Demonstrating traits "velocity" and "collision_detection"
#
class Bowl < Chingu::GameState
  def setup    
    FireCube.destroy_all
    self.input = {  :holding_space => :new_fire_cube,
                   :left => :decrease_speed,
                   :right => :increase_speed,
                   :up => :increase_size,
                   :down => :decrease_size,
                   :p => Pause,
                   :return => Splash
                 }
    6.times { new_fire_cube }
  end
  
  def new_fire_cube
    FireCube.create(:x => rand($window.width), :y => rand($window.height))
  end

  def increase_size
    game_objects.each { |go| go.factor += 1 }
  end
  def decrease_size
    game_objects.each { |go| go.factor -= 1 if go.factor > 1  }
  end
  def increase_speed
    game_objects.each { |go| go.velocity_x *= 2; go.velocity_y *= 2; }
  end
  def decrease_speed
    game_objects.each { |go| go.velocity_x *= 0.5; go.velocity_y *= 0.5; }
  end

  def update
    super
    
    FireCube.each do |particle|
      if particle.x < 0 || particle.x > $window.width
        particle.velocity_x = -particle.velocity_x
      end
      
      if particle.y < 0 || particle.y > $window.height
        particle.velocity_y = -particle.velocity_y
      end
    end
    
    #
    # GameObject.each_collsion / each_bounding_box_collision wont collide an object with itself
    #
    # FireCube.each_bounding_circle_collision(FireCube) do |cube1, cube2|  # 30 FPS on my computer
    #
    # Let's see if we can optimize each_collision, starts with 19 FPS with radius collision
    # 30 FPS by checking for radius and automatically delegate to each_bounding_circle_collision
    #
    # For bounding_box collision we start out with 7 FPS
    # Got 8 FPS, the bulk CPU consumtion is in the rect vs rect check, not in the loops.
    #
    FireCube.each_collision(FireCube) do |cube1, cube2|
      cube1.die!
      cube2.die!
    end
    
  end
  
  def draw
    $window.caption = "radius based iterative collision detection. Particles#: #{game_objects.size}, Collisionchecks each gameloop: ~#{game_objects.size**2} - FPS: #{$window.fps}"
    super
  end
end

#
# FireCube Class
#
class FireCube < Chingu::GameObject
  traits :velocity, :collision_detection, :bounding_circle
  attr_accessor :color
  
  def initialize(options)
    super
    @mode = :additive
    
    @image = Image["objects/circle.png"]
    
    # initialize with a rightwards velocity with some damping to look more realistic
    self.velocity_x = options[:velocity_x] || 1 + rand(2)
    self.velocity_y = options[:velocity_y] || 1 + rand(2)
    self.factor = 2
    
    @color = Color::BLUE
    
    cache_bounding_circle # This does a lot for performance
  end
  
  def update
    @color = Color::BLUE
  end
  
  def die!
    @color = Color::RED
  end
  
end


#
#  SPLASH GAMESTATE
#
# From Chingu Tutorial Demonstrating Chingu-traits bounding_circle, bounding_box and collision_detection.
#
class Splash < Chingu::GameState
  def setup    
    Circle.destroy_all
    Box.destroy_all
    self.input = { :return => Field, :left => :decrease_speed, :right => :increase_speed, :up => :increase_size, :down => :decrease_size, :holding_space => :new_circle, :p => Pause }
    20.times { Circle.create(:x => $window.width/2, :y => $window.height/2) }
    20.times { Box.create(:x => $window.width/2, :y => $window.height/2) }
  end
  
  def increase_size
    game_objects.each { |go| go.factor += 1 }
  end
  def decrease_size
    game_objects.each { |go| go.factor -= 1 if go.factor > 1  }
  end
  def increase_speed
    game_objects.each { |go| go.velocity_x *= 2; go.velocity_y *= 2; }
  end
  def decrease_speed
    game_objects.each { |go| go.velocity_x *= 0.5; go.velocity_y *= 0.5; }
  end
  def new_circle
    Circle.create(:x => rand($window.width), :y => rand($window.height))
  end

  def update
    super
    game_objects.each { |go| go.color = @white }
    [Box, Circle].each_collision(Box, Circle) { |o, o2| o.color, o2.color = @blue, @blue }
#    [Box, Circle].each_collision(Box, Circle) { |b| puts "b" }
  
    FireCube.each do |particle|
      if particle.x < 0 || particle.x > $window.width
        particle.velocity_x = -particle.velocity_x
      end
      
      if particle.y < 0 || particle.y > $window.height
        particle.velocity_y = -particle.velocity_y
      end
    end
    Box.each_collision(Circle) do |cube1, cube2|
      cube1.go_blue!
      cube2.go_blue!
    end
    Circle.each_collision(Circle) do |cube1, cube2|
      cube1.go_red!
      cube2.go_red!
    end
    Box.each_collision(Box) do |cube1, cube2|
      cube1.go_red!
      cube2.go_red!
    end
  end
  
  def draw
    $window.caption = "traits bounding_box/circle & collision_detection. Q/W: Size. A/S: Speed. FPS: #{fps} Objects: #{game_objects.size}"
    super
  end
end


#
#  CIRCLE CLASS
#
class Circle < GameObject
  trait :bounding_circle, :debug => true
  traits :velocity, :collision_detection
  
  def setup
    @image = Image["objects/circle.png"]
    self.velocity_x = (3 - rand * 6) * 2
    self.velocity_y = (3 - rand * 6) * 2
    cache_bounding_circle
  end

  def go_blue!
    @color = Color::BLUE
  end
  def go_red!
    @color = Color::RED
  end
    
  def update
    self.velocity_x = -self.velocity_x  if @x < 0 || @x > $window.width
    self.velocity_y = -self.velocity_y  if @y < 0 || @y > $window.height
  end
end


#
# BOX CLASS
#
class Box < GameObject
  trait :bounding_box, :debug => true
  traits :velocity, :collision_detection
  
  def setup
    @image = Image["objects/rect.png"]
    self.velocity_x = (3 - rand * 6) * 2
    self.velocity_y = (3 - rand * 6) * 2
    
    # Test to make sure the bounding_box works with all bellow combos
    #self.factor = 2
    #self.factor = -2
    self.rotation_center = :left_top
    #self.rotation_center = :center
    #self.rotation_center = :right_bottom
        
    cache_bounding_box
  end
  
  def go_blue!
    @color = Color::BLUE
  end
  def go_red!
    @color = Color::RED
  end

  def update
    self.velocity_x = -self.velocity_x  if @x < 0 || @x > $window.width
    self.velocity_y = -self.velocity_y  if @y < 0 || @y > $window.height
  end
end




#
#   CHINGU TIPS
#
    # Collide Boxes/Circles, Boxes/Boxes and Circles/Circles (basicly all objects on screen)
    #
    # Before optmization: 25 FPS  (20 boxes and 20 circles)
    # Cached radius and rects:
    #

    #
    # Only collide boxes with other boxes
    #
    ## Box.each_collision(Box) { |o, o2| o.color, o2.color = @blue, @blue }

    #
    # Only collide circles with other circles
    #
    ## Circle.each_collision(Circle) { |o, o2| o.color, o2.color = @blue, @blue }

    #
    # Only collide Boxes with Boxes and Circles
    #
    ## Box.each_collision(Box,Circle) { |o, o2| o.color, o2.color = @blue, @blue }

