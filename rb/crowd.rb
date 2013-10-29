
class CrowdScene < Chingu::GameState
  trait :timer
  def setup
    @bg = BackgroundCrowd.create
    self.input = {
      :esc => :exit,
      # [:right_shift, :left_shift] => OpeningCredits,
      :p => Pause,
      # :r => lambda{current_game_state.setup}
      :e => proc { @bg.input_e },
      :r => proc { @bg.input_r },
      :t => proc { @bg.input_t },
      :y => proc { @bg.input_y },
      :d => proc { @bg.input_d },
      :f => proc { @bg.input_f },
      :g => proc { @bg.input_g },
      :h => proc { @bg.input_h },
      :u => proc { @bg.input_u },
      :j => proc { @bg.input_j },
      :i => proc { @bg.input_i },
      :k => proc { @bg.input_k },
      :up   => proc { @bg.input_up },
      :down => proc { @bg.input_down },
      :left => proc { @bg.input_left },
      :right=> proc { @bg.input_right },
    }
  end
end


class BackgroundCrowd < Chingu::GameObject
#  attr_accessor :camera_x, :camera_y
  def setup
    %w[left right up down e r t y d f g h u j i k].each do |meth|
      method = :"input_#{meth}"
      self.define_singleton_method method do
        @characters.each { |char| char.send(method) }
      end
    end

#    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
    @parallax = Chingu::Parallax.create( :x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
    @rotation_center = :top_left
    @zorder = Zorder::Background
    #@parallax.add_layer(repeat_y: true, :image => "backgrounds/pub1.jpg", :damping => 16)
    #@parallax.add_layer(repeat_y: true, :image => "backgrounds/pub2.jpg")
    #@parallax.add_layer(repeat_y: true, :image => "backgrounds/bar3_bg.png")
    #@parallax.add_layer(repeat_y: true, :image => "backgrounds/bar3_fg.png")

    @bg_frame  = 0
    @bg_frames = 6
    @bg_path   = "backgrounds/bar3_crowd1.FRAME.png"

    @parallax.add_layer(image: "backgrounds/bar3_crowd1.1.png")
    @characters = []
    # @parallax.add_layer(repeat_y: true, :image => "backgrounds/space2.png", :damping => 12)
    # @parallax.add_layer(repeat_y: true, :image => "backgrounds/space3.png", :damping => 8)

    # @speed_x = 0
    # @speed_y = 8

    #30.times{ create_characters }
  end

  def update
    @flip ||= 0
    @flip += 1
    if @flip % 3 == 0
      @bg_frame = ( @bg_frame + 1 ) % @bg_frames
      #frame = ( @bg_frame - @bg_frames + 1 ).abs
      @parallax.layers.first.image = @bg_path.gsub(/FRAME/, @bg_frame.to_s)
    end
  end

  def create_characters # creates 15 characters (one of each) each time it is called 
    @characters << Char1.create
    @characters << Char2.create
    @characters << Char3.create
    @characters << Char4.create
    @characters << Char5.create
    @characters << Char6.create
    @characters << Char7.create
    @characters << Char8.create
    @characters << Char9.create
    @characters << Char10.create
    @characters << Char11.create
    @characters << Char12.create
    @characters << Char13.create
    @characters << Char14.create
    @characters << Char15.create
  end

  # def input_left
  #   @characters.each { |char| char.input_left }
  # end
  # def input_right
  #   @characters.each { |char| char.input_right }
  # end
  # def input_up
  #   @characters.each { |char| char.input_up }
  # end
  # def input_down
  #   @characters.each { |char| char.input_down }
  # end

  # def camera_left
  #   @parallax.camera_x -= @speed_x
  # end
  # def camera_right
  #   @parallax.camera_x += @speed_x
  # end  
  # def camera_up
  #   @parallax.camera_y -= @speed_y
  # end
  # def camera_down
  #   @parallax.camera_y += @speed_y
  # end

  # def update
  #   camera_up
  # end
end



#
#  CHARACTERS
#    called in ending.rb, in Ending3 gamestate
class Characters < Chingu::GameObject
  def initialize(options={})
    super
    self.x = rand(812) - 6       # place characters randomly all over

    # if rand(5) == 1
    #   self.y = rand(100) + 310
    # elsif rand(4) == 1
    #   self.y = rand(125) + 210
    # elsif rand(3) == 1
    #   self.y = rand(80) + 210
    # elsif rand(2) == 1
    #   self.y = rand(60) + 210
    # else
    #   self.y = rand(50) + 210
    # end

    # ## PUB 1
     @top          = 385
     @bottom       = 529
     #@bottom       = 500
     @top_left     = 510
     @top_right    = 655
     @bottom_left  = 105
     @bottom_right = 825

    # ## CARPET-ISH
    # @top          = 280
    # @bottom       = 490
    # @top_left     = 505
    # @top_right    = 550
    # @bottom_left  = 100
    # @bottom_right = 660

    # ## CARPET
    # @top          = 300
    # @bottom       = 600
    # @top_left     = 475
    # @top_right    = 560
    # @bottom_left  = -75
    # @bottom_right = 710

    # ## FULL BAR
    # @top          = 280
    # @bottom       = 600
    # @top_left     = 105
    # @top_right    = 540
    # @bottom_left  = -125
    # @bottom_right = 810
    # @top_gain     = 30
    # @bottom_gain  = 60

    ## FULL BAR
#    @top          = 290
#    @bottom       = 610
#    @top_left     = 370
#    @top_right    = 540
#    @bottom_left  = -410
#    @bottom_right = 810
    @top_gain     = 15
    @bottom_gain  = 40

    #@yy           = rand() ** 4.0
    @yy           = rand() ** 2.0
    @xx           = rand()

    @offset_x = 0
    @offset_y = 0

    # self.y = rand() ** 4.0 * 130 + 350
    #self.factor = (@y-300)/300.0  # character size is affected by y position
    #self.factor = 0.7
    self.factor = @yy * 0.7 + 0.4
    #self.zorder = self.factor.abs * 400
    self.zorder = @yy * 300
    #col = ((self.factor) * 2.0) ** 2.0 * 255
    # self.x = rand(self.factor * 800) + (1.0 - self.factor) * 500
  end

  def update
    if @printit
      prnt = <<eos.gsub(/^\s+/, "    ")
        @top          = #{@top}
        @bottom       = #{@bottom}
        @top_left     = #{@top_left}
        @top_right    = #{@top_right}
        @bottom_left  = #{@bottom_left}
        @bottom_right = #{@bottom_right}
        @top_gain     = #{@top_gain}
        @bottom_gain  = #{@bottom_gain}

eos
      puts prnt
      @printit = false
    end
    left_edge   = @yy * (@bottom_left  - @top_left)  + @top_left
    right_edge  = @yy * (@bottom_right - @top_right) + @top_right
    @y          = @offset_y + @yy * (@bottom - @top) + @top
    @x          = @offset_x + @xx * (right_edge - left_edge) + left_edge

    col = @yy * (@bottom_gain/100.0 - @top_gain/100.0) + @top_gain/100.0
    col *= 255
    #slice = @yy > 0.7 ? 255 : 0
    slice = 255
    self.color = Color.rgba(col, col*0.8, col*0.8, slice)


    if rand(50)  == 1; @offset_x += @motion; end   # random crowd movements
    if rand(50)  == 1; @offset_x -= @motion; end
    if rand(150) == 1; @offset_y += @motion; end
    if rand(150) == 1; @offset_y -= @motion; end
  end

  def input_e
    @top_left     -= 5 and @printit = true
  end
  def input_r
    @top_left     += 5 and @printit = true
  end
  def input_t
    @top_right    -= 5 and @printit = true
  end
  def input_y
    @top_right    += 5 and @printit = true
  end
  def input_d
    @bottom_left  -= 5 and @printit = true
  end
  def input_f
    @bottom_left  += 5 and @printit = true
  end
  def input_g
    @bottom_right -= 5 and @printit = true
  end
  def input_h
    @bottom_right += 5 and @printit = true
  end
  def input_u
    @top_gain     += 5 and @printit = true
  end
  def input_j
    @top_gain     -= 5 and @printit = true
  end
  def input_i
    @bottom_gain  += 5 and @printit = true
  end
  def input_k
    @bottom_gain  -= 5 and @printit = true
  end
  def input_up
    @top          += 5 and @printit = true
  end
  def input_down
    @top          -= 5 and @printit = true
  end
  def input_left
    @bottom       += 5 and @printit = true
  end
  def input_right
    @bottom       -= 5 and @printit = true
  end

end

# CHAR1 is included down below, after Char15

#
#  CHAR 2 - 15
#
class Char1 < Characters  # inherits from Characters class
  def setup
    @motion = 1
    @image = Gosu::Image["crowd/char1.png"]
  end
end

class Char2 < Characters  # inherits from Characters class
  def setup
    @motion = 1
    @image = Gosu::Image["players/shaman.png"]
  end
end

class Char3 < Characters  # inherits from Characters class
  def setup
    @motion = 1
    @image = Gosu::Image["players/tanooki.png"]
  end
end

class Char4 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["crowd/char4.png"]
  end
end

class Char5 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["crowd/char5.png"]
  end
end

class Char6 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["crowd/char6.png"]
  end
end

class Char7 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["players/sorceror.png"]
  end
end

class Char8 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["crowd/char8.png"]
  end
end

class Char9 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["players/boy.png"]
  end
end

class Char10 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["crowd/char10.png"]
  end
end

class Char11 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["crowd/char11.png"]
  end
end

class Char12 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["crowd/char12.png"]
  end
end

class Char13 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["players/villager.png"]
  end
end

class Char14 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["players/monk.png"]
  end
end

class Char15 < Characters
  def setup
    @motion = 1
    @image = Gosu::Image["crowd/char15.png"]
  end
end


