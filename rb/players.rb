DEBUG = false  # Set to true to see bounding circles used for collision detection


class CharWheel < Chingu::GameObject
  def setup
    @speed = 3
    @picture = ["boy", "monk", "tanooki",
                "cult_leader", "villager", "knight",
                "sorceror" ]
#    @picture = ["players/boy.png", "players/monk.png", "players/tanooki.png",
#                "players/cult_leader.png", "players/villager.png", "players/knight.png",
#                "players/sorceror.png" ]
    @p = 0
    @image = Gosu::Image["players/#{@picture[@p]}.png"]
#    @image = Gosu::Image[@picture[@p]]
    @click = Sound["media/audio/keypress.ogg"]
    @ready = false
  end

  def p
    @picture[@p]
  end

  def ready
    @ready = true
  end

=begin
  def go_left
    if @ready == false
      @click.play
      if @p > 0
        @p -= 1
      else
        @p = 6
      end
      @image = Gosu::Image["players/#{@picture[@p]}.png"]
      @text.text = "#{@picture[@p]}"
      $image1 = "#{@picture[@p]}"
#      @image = Gosu::Image[@picture[@p]]
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
#      @image = Gosu::Image[@picture[@p]]
    end
  end
=end
  def go_up
    @y -= @speed
  end

  def go_down
    @y += @speed
  end

  def enlargen
    if self.factor < 3.0
      self.factor *= 1.02
    end
  end

  def update
    if @ready == true
      enlargen
    end
  end

end


class CharWheel1 < CharWheel
  def setup
    self.factor = -1
    @speed = 3
    @picture = ["boy", "monk", "tanooki",
                "cult_leader", "villager", "knight",
                "sorceror" ]
#    @picture = ["players/boy.png", "players/monk.png", "players/tanooki.png",
#                "players/cult_leader.png", "players/villager.png", "players/knight.png",
#                "players/sorceror.png" ]
    @p = 0
    @image = Gosu::Image["players/#{@picture[@p]}.png"]
#    @image = Gosu::Image[@picture[@p]]
    @click = Sound["media/audio/keypress.ogg"]
    @ready = false

#    @caption = Chingu::Text.create("ttt#{$image1}", :y => self.y - 150, :size => 45, :color => Colors::Dark_Orange, :zorder => Zorder::GUI)
#    @caption.x = self.x - @caption.width/2 # center text
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
#      @caption.text = "#{@picture[@p]}"
#      @caption.x = @x - @caption.width/2 # center text
      $image1 = "#{@picture[@p]}"
#      @image = Gosu::Image[@picture[@p]]
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
#      @image = Gosu::Image[@picture[@p]]
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
#      @image = Gosu::Image[@picture[@p]]
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
#      @image = Gosu::Image[@picture[@p]]
    end
  end
end








class Player < Chingu::GameObject
  trait :bounding_box, :debug => DEBUG
  traits :velocity, :collision_detection
  def setup
    @speed = 12
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
end


class Referee < Player
    trait :bounding_circle, :debug => DEBUG
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

  def update
    if @growing == true
      grow_counter
      self.factor_x *= @growth
    end

    if rand(@rand) == 5
      @x += @speed
    end
    if rand(@rand) == 5
      @y += @speed
    end
    if rand(@rand) == 5
      @x -= @speed
    end
    if rand(@rand) == 5
      @y -= @speed
    end
  end
end


#
#  PLAYER 1 CLASS
#
class Player1 < Player
  attr_reader :health, :score
  def initialize(health)
    super
    @image = Gosu::Image["players/#{$image1}.png"]
    cache_bounding_box
  end

end


#
#  PLAYER 2 CLASS
#
class Player2 < Player
  attr_reader :health, :score
  def initialize(health)
    super
    @image = Gosu::Image["players/#{$image2}.png"]
    cache_bounding_box
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


