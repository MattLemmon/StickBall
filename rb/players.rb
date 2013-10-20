DEBUG = false  # Set to true to see bounding circles used for collision detection


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


#
#  REFEREE
#
class Referee < Player
    trait :bounding_circle, :debug => DEBUG
  def setup
#    super
    @image = Gosu::Image["players/referee.png"]
#    @picture2 = Gosu::Image["players/player_blink.png"]
    @rand = 30
    @speed = 5
    cache_bounding_circle
  end
  def update
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
    @image = Gosu::Image["players/boy_left.png"]
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
    @image = Gosu::Image["players/sorceror.png"]
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





