DEBUG = false  # Set to true to see bounding circles used for collision detection

require_relative 'face/mouth'
require_relative 'face/eyes'

class ModeSelect < Chingu::GameObject
  def setup
    @mode = ["Campaign", "Versus"]
    @m = 0
    @opponent = ["Computer", "A S D W"]
    @ready = false

    @text = Chingu::Text.create(@mode[@m], :y => 420, :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
    @text.x = 400 - @text.width/2 # center text
    @t2 = Chingu::Text.create(@opponent[@m], :y => 360, :font => "GeosansBold", :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
    @t2.x = 200 - @t2.width/2 # center text
#    @t4 = Chingu::Text.create("A S D W", :y => 360, :font => "GeosansBold", :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
#    @t4.x = 200 - @t4.width/2 # center text

  end

  def mode_select
    if @ready == false
      $click.play(0.6)
      if @m == 0
        @m = 1
      else
        @m = 0
      end
      @text.text = @mode[@m]
      @text.x = 400 - @text.width/2 # center text
      @t2.text = @opponent[@m]
      @t2.x = 200 - @t2.width/2 # center text
      $mode = @mode[@m]
    end
  end
end





class CharWheel < Chingu::GameObject
  def setup
    @speed = 3
    @picture = ["boy", "monk", "tanooki", "cult_leader",
                 "villager", "knight", "sorceror" ]
    @p = 0
    @health = [5, 10, 15, 20]
    @h = 1
    @image = Gosu::Image["players/#{@picture[@p]}.png"]
    @ready = false
  end
  def p
    @picture[@p]
  end
  def ready
    @ready = true
  end
  def update
    if @ready == true
      enlargen
    end
  end
end

#
#  CHARWHEEL 1
#
class CharWheel1 < CharWheel
  def setup
    self.factor_x = -1
    @speed = 3
    @picture = ["boy", "monk", "tanooki", "cult_leader",
                "villager", "knight", "sorceror" ]
    @p = 0
    @health = [5, 10, 15, 20]
    @h = 1
    @image = Gosu::Image["players/#{@picture[@p]}.png"]
    @ready = false
  end
  def go_left
    if @ready == false
      $click_right.play(0.7)
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
      $click_right.play(0.7)
      if @p < 6
        @p += 1
      else
        @p = 0
      end
      @image = Gosu::Image["players/#{@picture[@p]}.png"]
      $image1 = "#{@picture[@p]}"
    end
  end

  def go_up
    if @ready == false
      $click_right.play(0.7)
      if @h < 3
        @h += 1
      else
        @h = 0
      end
      $health1 = @health[@h]
    end
  end

  def go_down
    if @ready == false
      $click_right.play(0.7)
      if @h > 0
        @h -= 1
      else
        @h = 3
      end
      $health1 = @health[@h]
    end
  end

  def enlargen
    if self.factor_y < 3.0
      self.factor_x *= 1.02
      self.factor_y *= 1.02
    end
  end
end

#
#  CHARWHEEL 2
#
class CharWheel2 < CharWheel
  def go_left
    if @ready == false
      $click_left.play(0.7)
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
      $click_left.play(0.7)
      if @p < 6
        @p += 1
      else
        @p = 0
      end
      @image = Gosu::Image["players/#{@picture[@p]}.png"]
      $image2 = "#{@picture[@p]}"
    end
  end
  def go_up
    if @ready == false
      $click_left.play(0.7)
      if @h < 3
        @h += 1
      else
        @h = 0
      end
      $health2 = @health[@h]
    end
  end
  def go_down
    if @ready == false
      $click_left.play(0.7)
      if @h > 0
        @h -= 1
      else
        @h = 3
      end
      $health2 = @health[@h]
    end
  end
  def enlargen
    if self.factor < 3.0
      self.factor *= 1.02
    end
  end
end

=begin
#
#  EYES
#
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
=end

#
#  REFEREE
#
class Referee < Chingu::GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :velocity, :collision_detection
  attr_reader :direction

  def setup
#    super
    @image = Gosu::Image["players/referee.png"]
#    @picture2 = Gosu::Image["players/player_blink.png"]
    @rand = 60
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

  def update_face
    @eyes.update
  end

  def update
    if @growing == true
      grow_counter
      self.factor_x *= @growth
    end
    go_right if rand(@rand) == 1
    go_down  if rand(@rand) == 1
    go_left  if rand(@rand) == 1
    go_up    if rand(@rand) == 1
    update_face
  end
  def draw
    super
    @eyes.draw
  end
end

=begin
    if rand(@rand) == 1
      go_right
      update_face
    end
    if rand(@rand) == 1
      go_down  
      update_face
    end
    if rand(@rand) == 1
      go_left  
      update_face
    end
    if rand(@rand) == 1
      go_up    
      update_face
    end
=end
#    go_right and update_face if rand(@rand) == 1
#    go_down  and update_face if rand(@rand) == 1
#    go_left  and update_face if rand(@rand) == 1
#    go_up    and update_face if rand(@rand) == 1


#
#  PLAYER 1 CLASS
#
class Player1 < Chingu::GameObject
  traits :velocity, :collision_detection
  trait :bounding_box, :debug => DEBUG
  trait :timer
  attr_reader :health, :score, :direction, :mist
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
    @mist = false
    @speed = $speed1
    @eyes = Eyes.new self
    @mouth = Mouth.new self
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
    if $spell1 != "none"
      $spell_cast.play(0.9)
      puts "cast #{$spell1}"
      3.times { Spell1.create(:x=>@x, :y=>@y ) }
      $spell1 = "none"
    end
#    if $spell1 == "mist"
#      @player2.mist
#    end
  end
  def creep
    @creeping = true
  end
  def stun
#    puts $spell2
#    if $spell2 == "stun"
      Zapper.create(:x=>@x,:y=>@y)
      @stun = true
      $stunned.play(0.3)
      after(100) {$zapped.play(0.3)}
      after(2000) {@stun = false}
#    end
  end
  def mist
#    Zapper.create(:x=>@x,:y=>@y)
    @mist = true
    $misted.play(0.7)
    after(3000) {@mist = false}
  end

  def update_face
    @eyes.update
    @mouth.update
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
    update_face
    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
  end

  def draw
    if @mist == false
      super
      @eyes.draw
      @mouth.draw
    end
  end
end


#
#  PLAYER 2 CLASS
#
class Player2 < Chingu::GameObject
  traits :velocity, :collision_detection
  trait :bounding_box, :debug => DEBUG
  trait :timer
  attr_reader :health, :score, :direction, :mist
  def initialize(health)
    super
    @image = Gosu::Image["players/#{$image2}.png"]
    @direction = 1
    cache_bounding_box
  end
  def setup
    @eyes = Eyes.new self
    @mouth = Mouth.new self
    @speed = $speed2
    @creeping = false
    @stun = false
    @mist = false
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
    if $spell2 != "none"
      $spell_cast.play(0.9)
      puts "cast #{$spell2}"
      3.times { Spell2.create(:x=>@x, :y=>@y) }
    $spell2 = "none"
    end
  end
  def creep
    @creeping = true
  end
  def stun
    Zapper.create(:x=>@x,:y=>@y)
    @stun = true
    $stunned.play(0.3)
    after(100) {$zapped.play(0.3)}
    after(2000) {@stun = false}
  end
  def mist
    @mist = true
    $misted.play(0.7)
    after(3000) {@mist = false}
  end

  def update_face
    @eyes.update
    @mouth.update
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
    update_face
    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
  end

  def draw
    if @mist == false
      super
      @eyes.draw
      @mouth.draw
    end
  end
end


#
#   OLD EYES
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
#
class Knight < Chingu::GameObject
  def initialize(options)
    super
    @image = Image["players/knight.png"]
    @voice = Sound["audio/mumble.ogg"]
    @velox = 0     # x velocity starts as 0
    @veloy = 0     # y velocity starts as 0
    @factoring = 1
  end
  def movement
    @velox = -7  # move left
  end
  def enter_ship
    @veloy = 2
    @factoring = 0.98
  end
  def speak
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


