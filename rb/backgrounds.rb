#
# PLAX 1
#
class Plax1 < Chingu::GameObject
  def setup
    @image = Image["backgrounds/space1.png"]
    @x = 0
  end
  def draw
    @image.draw(@x, 0, 10)
    @image.draw(@x + 480, 0, 10)
  end
  def update
    @x -= 10
  end

end







#
# BACKGROUND 3
#
class Background3 < Chingu::GameObject
#  attr_accessor :camera_x, :camera_y
  def setup
#    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
    @x = 0
    @y = 0
    @rotation_center = :top_left
    @zorder = Zorder::Background
    add_layer(:image => "backgrounds/space1.png", :damping => 16)
    add_layer(:image => "backgrounds/space2.png", :damping => 12)
    add_layer(:image => "backgrounds/space3.png", :damping => 8)

    @speed_x = 20
    @speed_y = 2
  end

  def camera_left
    @camera_x -= @speed_x
  end
  def camera_right
    @camera_x += @speed_x
  end  
  def camera_up
    @camera_y -= @speed_y
  end
  def camera_down
    @camera_y += @speed_y
  end

  def update
    camera_right
    camera_down
  end
end




#
# BACKGROUND 1
#
class Background1 < Chingu::Parallax
#  attr_accessor :camera_x, :camera_y
  def setup
#    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
    @x = 0
    @y = 0
    @rotation_center = :top_left
    @zorder = Zorder::Background
    add_layer(:image => "backgrounds/space1.png", :damping => 16)
    add_layer(:image => "backgrounds/space2.png", :damping => 12)
    add_layer(:image => "backgrounds/space3.png", :damping => 8)

    @speed_x = 20
    @speed_y = 2
  end

  def camera_left
    @camera_x -= @speed_x
  end
  def camera_right
    @camera_x += @speed_x
  end  
  def camera_up
    @camera_y -= @speed_y
  end
  def camera_down
    @camera_y += @speed_y
  end

  def update
    camera_right
    camera_down
  end
end



#
# BACKGROUND 2
#
class Background2 < Chingu::GameObject
  
  def setup
    @parallax = Chingu::Parallax.create( :repeat_y => true, :x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
    @parallax.add_layer(:image => "backgrounds/space1.png", :damping => 16)
    @parallax.add_layer(:image => "backgrounds/space2.png", :damping => 12)
    @parallax.add_layer(:image => "backgrounds/space3.png", :damping => 8)

    @speed_x = 8
    @speed_y = 0
    @mult_y = 0.0
    @count = 0
    @max_count = 20
    @motion_cycle = 1
  end

  def camera_left
    @parallax.camera_x -= @speed_x
  end
  def camera_right
    @parallax.camera_x += @speed_x
  end  
  def camera_up
    @parallax.camera_y -= @speed_y
  end
  def camera_down
    @parallax.camera_y += @speed_y
  end

#  def camera_right_fast
#    @parallax.camera_x += 40
#  end  
#  def camera_down_fast
#    @parallax.camera_y += 40
#  end  

  def motion_change
    puts @motion_cycle

    # UP
    if @motion_cycle == 1
      @speed_x = 10
      @speed_y = 2
    end
    if @motion_cycle == 2
      @speed_x = 15
      @speed_y = 3
    end
    if @motion_cycle == 3
      @speed_x = 20
      @speed_y = 5
    end
    if @motion_cycle == 4
      @speed_x = 25
      @speed_y = 9
    end

    #MIDDLE
    if @motion_cycle == 5
      @speed_x = 30
      @speed_y = 10
    end



    #DOWN
    if @motion_cycle == 6
      @speed_x = 25
      @speed_y = -9
    end
    if @motion_cycle == 7
      @speed_x = 20
      @speed_y = -5
    end
    if @motion_cycle == 8
      @speed_x = 15
      @speed_y = -3
    end
    if @motion_cycle == 9
      @speed_x = 10
      @speed_y = -2
      @motion_cycle = 0
    end

    if @motion_cycle == 10
      @speed_x = 8
      @speed_y = 0
    end

    @motion_cycle += 1
    puts @motion_cycle
  end


  def update
    if @count < @max_count
      @count += 1
    else
      @count = 0
      motion_change
      puts @motion_cycle
#      puts "motion_change"
    end
      camera_right
      camera_down

#    if @motion_cycle == 1
#      camera_right
#      camera_down
#    else
#      camera_right #_fast
#      camera_down_fast
#    end
  end
end