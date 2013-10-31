DEBUG = false  # Set to true to see bounding circles used for collision detection

require_relative 'face/mouth'
require_relative 'face/eyes'

class ModeSelect < Chingu::GameObject
  def setup
    @opponent = ["A S D W", "Computer"]
    @mode = ["Versus", "Campaign"]
    @m = 0
    @difficulty = ["Easy", "Normal", "Hard", "Insane"]
    @diff = 1

    @left_shift_text = ["Left Shift", ""]
    @left_ctrl_text = ["Left Ctrl", ""]
    @ready = false

    @text = Chingu::Text.create(@mode[@m], :y => 190, :size => 66, :zorder => Zorder::GUI)
    @text.x = 400 - @text.width/2 # center text

    @t2 = Chingu::Text.create(@opponent[@m], :y => 370, :size => 40, :font => "GeosansBold", :zorder => Zorder::GUI)
    @t2.x = 200 - @t2.width/2 # center text
    @text4 = Chingu::Text.create("Left Shift", :y => 430, :size => 38, :zorder => Zorder::GUI)
    @text4.x = 200 - @text4.width/2 # center text
    @text6 = Chingu::Text.create("Left Ctrl", :y => 490, :size => 38, :zorder => Zorder::GUI)
    @text6.x = 200 - @text6.width/2 # center text

    @diff_text = Chingu::Text.create("", :y => 370, :size => 40, :font => "GeosansBold", :zorder => Zorder::GUI)
#    @diff_text.x = 400 - @diff_text.width/2 # center text

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
      @text4.text = @left_shift_text[@m]
      @text4.x = 200 - @text4.width/2 # center text
      @text6.text = @left_ctrl_text[@m]
      @text6.x = 200 - @text6.width/2 # center text
      $mode = @mode[@m]
      if $mode == "Campaign"
        @diff_text.text = $difficulty
        @diff_text.x = 400 - @diff_text.width/2
      else
        @diff_text.text = ""
      end
    end
  end

  def go_up
    if $mode == "Campaign"
      $click.play(0.7)
      if @diff < 3
        @diff += 1
      else
        @diff = 0
      end
      @diff_text.text = @difficulty[@diff]
      @diff_text.x = 400 - @diff_text.width/2
      $difficulty = @difficulty[@diff]

    end
  end

  def go_down
    if $mode == "Campaign"
      $click.play(0.7)
      if @diff > 0
        @diff -= 1
      else
        @diff = 3
      end
      @diff_text.text = @difficulty[@diff]
      @diff_text.x = 400 - @diff_text.width/2
      $difficulty = @difficulty[@diff]
    end
  end

end





class Player1Clone < Chingu::GameObject
  attr_reader :direction
  def setup
    @image = Gosu::Image["players/#{$image1}.png"]
    @direction = -1
    @eyes = CloneEyes.new self
    self.factor_x = -1
  end
  def go_left
    @x -= 2
  end
   def go_right
    @x += 2
  end
  def go_up
    @y -= 2
  end
  def go_down
    @y += 2
  end
  def update
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


class Player2Clone < Chingu::GameObject
  attr_reader :direction
  def setup
    @image = Gosu::Image["players/#{$image2}.png"]
    @direction = 1
    @eyes = CloneEyes.new self
  end
  def go_left
    @x -= 2
  end
   def go_right
    @x += 2
  end
  def go_up
    @y -= 2
  end
  def go_down
    @y += 2
  end
  def update
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


class CharWheel < Chingu::GameObject
  def setup
    @speed = 3
    @picture = ["boy", "monk", "tanooki", "shaman",
                 "villager", "knight", "ninja", "sorceror" ]
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
    @picture = ["boy", "monk", "tanooki", "shaman",
                "villager", "knight", "ninja", "sorceror" ]
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
        @p = 7
      end
      @image = Gosu::Image["players/#{@picture[@p]}.png"]
      $image1 = "#{@picture[@p]}"
    end
  end
  def go_right
    if @ready == false
      $click_right.play(0.7)
      if @p < 7
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
      $start_health1 = $health1
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
      $start_health1 = $health1
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
        @p = 7
      end
      @image = Gosu::Image["players/#{@picture[@p]}.png"]
      $image2 = "#{@picture[@p]}"
    end
  end
  def go_right
    if @ready == false
      $click_left.play(0.7)
      if @p < 7
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
      $start_health2 = $health2
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
      $start_health2 = $health2
    end
  end
  def enlargen
    if self.factor < 3.0
      self.factor *= 1.02
    end
  end
end

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
  attr_reader :direction, :mist, :creeping

  def initialize(options)
    super
    @image = Gosu::Image["players/#{$image1}.png"]
    cache_bounding_box
  end
  def setup
    self.factor_x = -1
    @creeping = false
    @stun = false
    @mist = false
    @speed = $speed1
    @direction = -1
    @squeeze_y = 1.0
    @hit_time = Gosu.milliseconds - 3000
    @wobble_resistance = 0.008
    @eyes = Eyes.new self
    @mouth = Mouth.new self
    @last_x, @last_y = @x, @y
  end
  def go_left
    @velocity_x -= @speed
  end
  def go_right
    @velocity_x += @speed
  end
  def go_up
    @velocity_y -= @speed
#    @squeeze_y = walk_wobble_factor
  end
  def go_down
    @velocity_y += @speed
#    @squeeze_y = walk_wobble_factor
  end
#  def walk_wobble_factor  #sin curve between 1..0.8 at 5hz
#    1 - (Math.sin(Gosu.milliseconds/(Math::PI*10))+1)/10.0
#  end
  def hit_wobble_factor
    time = Gosu.milliseconds - @hit_time
    1 - (Math.sin(time/25.0)/(time**1.7*@wobble_resistance))
  end
  def wobble
    @hit_time = Gosu.milliseconds - 30
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
      after(3000) {@stun = false}
#    end
  end
  def mist
    after(300) {@mist = true}
    smog_cover
    $misted.play
    after(3000) {@mist = false}
  end
  def smog_cover
    Smog.create(:x=>@x,:y=>@y)
    after(100) {Smog.create(:x=>@x,:y=>@y)}
    after(200) {Smog.create(:x=>@x,:y=>@y)}
    after(300) {Smog.create(:x=>@x,:y=>@y)}
    after(400) {Smog.create(:x=>@x,:y=>@y)}
    after(500) {Smog.create(:x=>@x,:y=>@y)}
    after(600) {Smog.create(:x=>@x,:y=>@y)}
  end

  def update_face
    @eyes.update
    @mouth.update
  end


  def update
    self.factor_y = @squeeze_y
    self.factor_x = hit_wobble_factor * @direction
    @squeeze_y = 1.0
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

    # Particles
    if @mist == false
      if @velocity_x < 0.1 && @velocity_x > -0.1 && @velocity_y < 0.1 && @velocity_y > -0.1
        @part_vel_x = rand(50)/10 + 0.5
        if rand(2) == 1
          @part_vel_x *= -1
        end
        @part_vel_y = rand(50)/10 + 0.5
        if rand(2) == 1
          @part_vel_y *= -1
        end
#        @part_vel_x = (-2 + rand(5))*3
#        @part_vel_y = (-2 + rand(5))*3
      else
        @part_vel_x = -@velocity_x * 1.5
        @part_vel_y = -@velocity_y * 1.5
      end
      Particulate.create(:x => @x, :y => @y,
            :image => "objects/particle_2.png", 
            :color => 0xFF491B00,#963800,#0xFF00036F,
            :mode => :additive,
            :fade_rate => -10,
#            :angle => @angle,
            :factor => 1.7,
            :velocity_x => @part_vel_x,
            :velocity_y => @part_vel_y,
            :zorder => Zorder::Main_Character_Particles)
      Particulate.destroy_if { |object| object.color.alpha == 0 }
    end

    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
#    @last_x, @last_y = @x, @y

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
  attr_reader :direction, :mist, :creeping

  def initialize(options)
    super
    @image = Gosu::Image["players/#{$image2}.png"]
    @direction = 1
    cache_bounding_box
  end
  def setup
    @creeping = false
    @stun = false
    @mist = false
    @speed = $speed2
    @direction = 1
    @squeeze_y = 1.0
    @hit_time = Gosu.milliseconds - 3000
    @wobble_resistance = 0.008
    @eyes = Eyes.new self
    @mouth = Mouth.new self
#    @last_x, @last_y = @x, @y
  end
  def walk_wobble_factor  #sin curve between 1..0.8 at 5hz
    1 - (Math.sin(Gosu.milliseconds/(Math::PI*10))+1)/10.0
  end
  def hit_wobble_factor
    time = Gosu.milliseconds - @hit_time
    1 - (Math.sin(time/25.0)/(time**1.7*@wobble_resistance))
  end
  def wobble
    @hit_time = Gosu.milliseconds - 30
  end
  def go_left
    @velocity_x -= @speed
  end
  def go_right
    @velocity_x += @speed
  end
  def go_up
    @velocity_y -= @speed
#    @squeeze_y = walk_wobble_factor
  end
  def go_down
    @velocity_y += @speed
#    @squeeze_y = walk_wobble_factor
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
    after(3000) {@stun = false}
  end
  def mist
    after(300) {@mist = true}
    smog_cover
    $misted.play
    after(3000) {@mist = false}
  end
  def smog_cover
    Smog.create(:x=>@x,:y=>@y)
    after(100) {Smog.create(:x=>@x,:y=>@y)}
    after(200) {Smog.create(:x=>@x,:y=>@y)}
    after(300) {Smog.create(:x=>@x,:y=>@y)}
    after(400) {Smog.create(:x=>@x,:y=>@y)}
    after(500) {Smog.create(:x=>@x,:y=>@y)}
    after(600) {Smog.create(:x=>@x,:y=>@y)}
  end

  def update_face
    @eyes.update
    @mouth.update
  end

  def update
    self.factor_y = @squeeze_y
    self.factor_x = hit_wobble_factor * @direction
    @squeeze_y = 1.0
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
    # Particles
    if @mist == false
      if @velocity_x < 0.1 && @velocity_x > -0.1 && @velocity_y < 0.1 && @velocity_y > -0.1
        @part_vel_x = rand(50)/10 + 0.5
        if rand(2) == 1
          @part_vel_x *= -1
        end
        @part_vel_y = rand(50)/10 + 0.5
        if rand(2) == 1
          @part_vel_y *= -1
        end
      else
        @part_vel_x = -@velocity_x * 1.5
        @part_vel_y = -@velocity_y * 1.5
      end
      Particulate.create(:x => @x, :y => @y,
            :image => "objects/particle_2.png", 
            :color => 0xFF491B00,#963800,#0xFF00036F,
            :mode => :additive,
            :fade_rate => -10,
#            :angle => @angle,
            :factor => 1.7,
            :velocity_x => @part_vel_x,
            :velocity_y => @part_vel_y,
            :zorder => Zorder::Main_Character_Particles)
      Particulate.destroy_if { |object| object.color.alpha == 0 }
    end
    if @x < -$scr_edge; @x = $max_x; end  # wrap beyond screen edge
    if @y < -$scr_edge; @y = $max_y; end
    if @x > $max_x; @x = -$scr_edge; end
    if @y > $max_y; @y = -$scr_edge; end
#    @last_x, @last_y = @x, @y
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
