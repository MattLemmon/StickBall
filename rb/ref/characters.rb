#
#  KNIGHT
#    called in beginning.rb, in Introduction gamestate
class Knight < Chingu::GameObject
  def initialize(options)
    super
    @image = Image["media/assets/knight.png"]
    @voice = Sound["media/audio/mumble.ogg"]
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

#
#  END KNIGHT
#    called in ending.rb, in Ending3 gamestate
class EndKnight < Chingu::GameObject
  def setup
    @image = Image["media/assets/knight_left.png"]
  end
  def update
    @x -= 2.2  # EndKnight starts offscreen and continually moves to the left
  end
end


#
#  CHARACTERS
#    called in ending.rb, in Ending3 gamestate
class Characters < Chingu::GameObject
  def initialize(options={})
    super
    self.x = rand(812) - 6       # place characters randomly all over

    if rand(5) == 1
      self.y = rand(100) + 310
    elsif rand(4) == 1
      self.y = rand(125) + 210
    elsif rand(3) == 1
      self.y = rand(80) + 210
    elsif rand(2) == 1
      self.y = rand(60) + 210
    else
      self.y = rand(50) + 210
    end
  end

  def update 
    self.factor = (@y-150)/400.0  # character size is affected by y position
    self.zorder = @y              # character zorder is affected by y position
    if rand(50) == 1; @x += @motion; end   # random crowd movements
    if rand(50) == 1; @x -= @motion; end
    if rand(150) == 1; @y += @motion; end
    if rand(150) == 1; @y -= @motion; end
  end
end

# CHAR1 is included down below, after Char15

#
#  CHAR 2 - 15
#
class Char2 < Characters  # inherits from Characters class
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char2.png"]
  end
end

class Char3 < Characters  # inherits from Characters class
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char3.png"]
  end
end

class Char4 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char4.png"]
  end
end

class Char5 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char5.png"]
  end
end

class Char6 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char6.png"]
  end
end

class Char7 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char7.png"]
  end
end

class Char8 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char8.png"]
  end
end

class Char9 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char9.png"]
  end
end

class Char10 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char10.png"]
  end
end

class Char11 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char11.png"]
  end
end

class Char12 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char12.png"]
  end
end

class Char13 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char13.png"]
  end
end

class Char14 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char14.png"]
  end
end

class Char15 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char15.png"]
  end
end


#
#  CHARACTER 1 
#    Char1 can be controlled with the arrow keys in Ending3 gamestate
class Char1 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["assets/characters/char1.png"]
    self.input = [:holding_left, :holding_right, :holding_up, :holding_down ]
  end
  def holding_left;  @x -= 8;  end
  def holding_right; @x += 8;  end
  def holding_up;    @y -= 8;  end
  def holding_down;  @y += 8;  end
end


#
#  CROWD
#    Enormous background multitude
class Crowd < Chingu::GameObject
  def setup           # this is a ten-frame animation
    @c1 = Gosu::Image["assets/crowd/crowd1.png"]
    @c2 = Gosu::Image["assets/crowd/crowd2.png"]
    @c3 = Gosu::Image["assets/crowd/crowd3.png"]
    @c4 = Gosu::Image["assets/crowd/crowd4.png"]
    @c5 = Gosu::Image["assets/crowd/crowd5.png"]
    @c6 = Gosu::Image["assets/crowd/crowd6.png"]
    @c7 = Gosu::Image["assets/crowd/crowd7.png"]
    @c8 = Gosu::Image["assets/crowd/crowd8.png"]
    @c9 = Gosu::Image["assets/crowd/crowd9.png"]
    @c10 = Gosu::Image["assets/crowd/crowd10.png"]

    @image = @c1
    @count = 0    # counter for delay between frames
    @current = 0  # current frame number
    @pendulum = 1 # positive one at start
    @crowds = [@c1,@c2,@c3,@c4,@c5,@c6,@c7,@c8,@c9,@c10]  # array of images -- basic animation loop
  end

  def next_image   # called once every 6 ticks in update
    @current += @pendulum
    if @current == 9       # @current goes from 0 up to 9, back down to 0, back up to 9...
      @pendulum = -1       # count back down from 9
    elsif @current == 0
      @pendulum = 1        # count back up from 0
    end
    @image = @crowds[@current]   # switch to next animation frame [@c1, @c2, etc.]
  end

  def update
    @count += 1
    if @count == 6    # 6-tick delay between frames
      @count = 0
      next_image
    end
  end
end


