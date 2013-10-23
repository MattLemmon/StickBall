DEBUG = false  # Set to true to see bounding circles used for collision detection


class CharWheel < Chingu::GameObject
  def setup
    @speed = 3
    @picture = ["boy", "monk", "tanooki", "cult_leader",
                 "villager", "knight", "sorceror" ]
    @p = 0
    @image = Gosu::Image["players/#{@picture[@p]}.png"]
    @click = Sound["media/audio/keypress.ogg"]
    @ready = false
  end
  def p
    @picture[@p]
  end
  def ready
    @ready = true
  end
  def go_up
    @y -= @speed
  end
  def go_down
    @y += @speed
  end
  def update
    if @ready == true
      enlargen
    end
  end
end


class CharWheel1 < CharWheel
  def setup
    self.factor_x = -1
    @speed = 3
    @picture = ["boy", "monk", "tanooki", "cult_leader",
                "villager", "knight", "sorceror" ]
    @p = 0
    @image = Gosu::Image["players/#{@picture[@p]}.png"]
    @click = Sound["media/audio/keypress.ogg"]
    @ready = false
  end
  def go_left
    if @ready == false
      @click.play
      if @p > 0
        @p -= 1
      else
        @p = 6
      end
      @image = Gosu::Image["players/#{@picture[@p]}.png"]
      $image1 = "#{@picture[@p]}"
    end
  end
  def go_right
    if @ready == false
      @click.play
      if @p < 6
        @p += 1
      else
        @p = 0
      end
      @image = Gosu::Image["players/#{@picture[@p]}.png"]
      $image1 = "#{@picture[@p]}"
    end
  end
  def enlargen
    if self.factor_y < 3.0
      self.factor_x *= 1.02
      self.factor_y *= 1.02
    end
  end
end


class CharWheel2 < CharWheel
  def go_left
    if @ready == false
      @click.play
      if @p > 0
        @p -= 1
      else
        @p = 6
      end
      @image = Gosu::Image["players/#{@picture[@p]}.png"]
      $image2 = "#{@picture[@p]}"
    end
  end
  def go_right
    if @ready == false
      @click.play
      if @p < 6
        @p += 1
      else
        @p = 0
      end
      @image = Gosu::Image["players/#{@picture[@p]}.png"]
      $image2 = "#{@picture[@p]}"
    end
  end
  def enlargen
    if self.factor < 3.0
      self.factor *= 1.02
    end
  end
end

class Eyes
  def initialize parent
    @parent = parent
    @image = Gosu::Image["players/eye_sockets.png"]
    @eye_ball = Gosu::Image["players/eye_ball.png"]
    @x = 0
    @y = 0
  end
  
  def update
    @x = @parent.x + 3 * @parent.direction
    @y = @parent.y - 6
    puck = @parent.game_state.puck
    @eye_angle = Gosu.angle @x, @y, puck.x, puck.y
  end
  
  def draw
    @image.draw_rot @x, @y, Zorder::Eyes, 0, 0.5, 1.0
    @eye_ball.draw_rot @x-7+Gosu.offset_x(@eye_angle, 3), @y-2+Gosu.offset_y(@eye_angle, 2), Zorder::Eyes, 0, 0.5, 1.0
    @eye_ball.draw_rot @x+7+Gosu.offset_x(@eye_angle, 3), @y-2+Gosu.offset_y(@eye_angle, 2), Zorder::Eyes, 0, 0.5, 1.0
  end
end


class Referee < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection
  attr_reader :direction

  def setup
#    super
    @image = Gosu::Image["players/referee.png"]
#    @picture2 = Gosu::Image["players/player_blink.png"]
    @rand = 30
    @speed = 5
    @growing = false
    @grow = 1
    @growth = 1.01
    @grow_count = 0
    @direction = 1
    @eyes = Eyes.new self
    cache_bounding_circle
  end

  def wobble
    if @grow_count == 0
#      @grow_count = 0
      @growth = 1.06
      @growing = true
    end
  end

  def grow_counter
    @grow_count += @grow
    if @grow_count >= 8
      @grow *= -1
      @growth = 0.95
    end
    if @grow_count == 0
      self.factor_x = 1.0
      @grow = 1
      @growing = false
    end
  end

  def go_left
    @x -= @speed
  end
  def go_right
    @x += @speed
  end
  def go_up
    @y -= @speed
  end
  def go_down
    @y += @speed
  end

  def update
    @eyes.update
    if @growing == true
      grow_counter
      self.factor_x *= @growth
    end
    go_right if rand(@rand) == 5
    go_down  if rand(@rand) == 5
    go_left  if rand(@rand) == 5
    go_up    if rand(@rand) == 5
  end

  def draw
    super
    @eyes.draw
  end
end


#
#  PLAYER 1 CLASS
#
class Player1 < Chingu::GameObject
  traits :velocity, :collision_detection
  trait :bounding_box, :debug => DEBUG
  trait :timer
  attr_reader :health, :score, :direction
  def initialize(health)
    super
    @image = Gosu::Image["players/#{$image1}.png"]
    self.factor_x = -1
    @direction = -1
    cache_bounding_box
  end
  def setup
    @creeping = false
    @stun = false
    @speed = $speed1
    @eyes = Eyes.new self
  end
  def go_left
    @velocity_x = -@speed
  end
  def go_right
    @velocity_x = @speed
  end
  def go_up
    @velocity_y = -@speed
  end
  def go_down
    @velocity_y = @speed
  end
  def cast_spell
    puts "cast #{$spell1}"
    @spell = Spell.create(:x=>@x, :y=>@y, :velocity_x=>-5)
#    @spell.velocity_y = 1
    $spell1 = "none"
  end
  def creep
    @creeping = true
  end
  def stun
    Zapper.create(:x=>@x,:y=>@y)
    @stun = true
    after(2000) {@stun = false}
  end

  def update
    if @stun == true
      @speed = 0
    elsif @creeping == true
      @speed = 5
    else
      @speed = $speed1
    end
    @creeping = false
    @velocity_x *= 0.25
    @velocity_y *= 0.25
    @eyes.update
    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
  end

  def draw
    super
    @eyes.draw
  end
end


#
#  PLAYER 2 CLASS
#
class Player2 < Chingu::GameObject
  traits :velocity, :collision_detection
  trait :bounding_box, :debug => DEBUG
  trait :timer
  attr_reader :health, :score, :direction
  def initialize(health)
    super
    @image = Gosu::Image["players/#{$image2}.png"]
    @direction = 1
    cache_bounding_box
  end
  def setup
    @eyes = Eyes.new self
    @speed = $speed2
    @creeping = false
    @stun = false
  end
  def go_left
    @velocity_x -= @speed
  end
  def go_right
    @velocity_x += @speed
  end
  def go_up
    @velocity_y -= @speed
  end
  def go_down
    @velocity_y += @speed
  end
  def cast_spell
    puts "cast #{$spell2}"
    @spell = Spell.create(:x=>@x, :y=>@y, :velocity_x=>5)
#    @spell.velocity_y = 1
    $spell2 = "none"
  end
  def creep
    @creeping = true
  end
  def stun
    Zapper.create(:x=>@x,:y=>@y)
    @stun = true
    after(2000) {@stun = false}
  end

  def update
    if @stun == true
      @speed = 0
    elsif @creeping == true
      @speed = 5
    else
      @speed = $speed2
    end
    @creeping = false
    @velocity_x *= 0.25
    @velocity_y *= 0.25
    @eyes.update
    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
  end

  def draw
    super
    @eyes.draw
  end
end


#
#   EYES
#
class EyesLeft < Chingu::GameObject
  def setup
    @image = Gosu::Image["players/eyes_left.png"]
  end
end

class EyesRight < Chingu::GameObject
  def setup
    @image = Gosu::Image["players/eyes_right.png"]
  end
end


#
#  KNIGHT
#    called in beginning.rb, in Introduction gamestate
class Knight < Chingu::GameObject
  def initialize(options)
    super
    @image = Image["players/knight.png"]
    @voice = Sound["audio/mumble.ogg"]
    @velox = 0     # x velocity starts as 0
    @veloy = 0     # y velocity starts as 0
    @factoring = 1 # used for shrinking Knight when he enters the ship
  end
  def movement   # called in Introduction gamestate
    @velox = -7  # move left
  end
  def enter_ship # called in Introduction gamestate
    @veloy = 2
    @factoring = 0.98
  end
  def speak      # called in Introduction gamestate
    @voice.play
  end
  def update
    self.factor *= @factoring
    @x += @velox
    @y += @veloy
    if @x <= 400; @velox = 0; end
    if @y >= 450; @veloy = 0; end
  end
end


