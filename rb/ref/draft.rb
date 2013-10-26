#
# BACKGROUND 1
#
class Background1 < Chingu::GameObject
  
  def setup
    @parallax1 = Image["backgrounds/space1.png"]
    @parallax2 = Image["backgrounds/space2.png"]
    @parallax3 = Image["backgrounds/space3.png"]
    @parallax4 = Image["backgrounds/space1.png"]
    @parallax5 = Image["backgrounds/space2.png"]
    @parallax6 = Image["backgrounds/space3.png"]

#    @parallax1.x = 0
#    @parallax1.y = 0
#    @parallax2.x = 0
#    @parallax2.y = 0
#    @parallax3.x = 0
#    @parallax3.y = 0
#    @parallax4.x = 0
    @parallax4.y = -800
    @parallax5.y = -800
    @parallax6.y = -800



#    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
#    @parallax.add_layer(:image => "backgrounds/space1.png", :damping => 16)
#    @parallax.add_layer(:image => "backgrounds/space2.png", :damping => 12)
#    @parallax.add_layer(:image => "backgrounds/space3.png", :damping => 8)
#    @parallax2 = Chingu::Parallax.create(:x => 0, :y => -800, :rotation_center => :top_left, :zorder => Zorder::Background)
#    @parallax2.add_layer(:image => "backgrounds/space1.png", :damping => 16)
#    @parallax2.add_layer(:image => "backgrounds/space2.png", :damping => 12)
#    @parallax2.add_layer(:image => "backgrounds/space3.png", :damping => 8)
  end


  def left
    @parallax1.x += 2
    @parallax2.x += 2
    @parallax3.x += 2
    @parallax4.x += 2

  end

  def right
#    @parallax.x += 2     # This is essentially the same as @parallax.x -= 2
#    @parallax2.x += 3
  end  
  def camera_up
#    @parallax.camera_y -= 1     # This is essentially the same as @parallax.y += 2
#    @parallax2.camera_y -= 5
  end
  def camera_down
#    @parallax.camera_y += 1    # This is essentially the same as @parallax.y -= 2
#    @parallax2.camera_y += 5
  end

  def update
    camera_right
    camera_up
  end
end








  def draw
    $window.post_process @mist do
      fill_gradient(:from => Color.new(255,0,0,0), :to => Color.new(255,60,60,80), :rect => [0,0,$window.width,@ground_y])
      fill_gradient(:from => Color.new(255,100,100,100), :to => Color.new(255,50,50,50), :rect => [0,@ground_y,$window.width,$window.height-@ground_y])    
      super
      @lense_flares.draw
    end
  end

=begin
#    @lense_flares.draw
    if @player1.mist == true or @player2.mist == true
      $window.post_process @mist do
        super
        @lense_flares.draw
      end
    elsif @transition == false
      fill_gradient(:from => Color.new(255,0,0,0), :to => Color.new(255,60,60,80), :rect => [0,0,$window.width,@ground_y])
      fill_gradient(:from => Color.new(255,100,100,100), :to => Color.new(255,50,50,50), :rect => [0,@ground_y,$window.width,$window.height-@ground_y])
      super
      @lense_flares.draw
    else
      super
    end
  end
=end

  def update
      $window.caption = "Stick Ball!     Go team go!                                             Objects: #{game_objects.size}, FPS: #{$window.fps}"

    if @transition == false
      @puck_flare.x = @puck.x
      @puck_flare.y = @puck.y
      @puck_flare.color = @puck.color
      @lense_flares.update
      @mist.time = Gosu.milliseconds/1000.0
    end
    super

    move_referee
    collision_check
    if @bump > 0
      @bump -= 1
    end
    if @bounce > 0
      @bounce -= 1
    end

    @score1_text.text = "#{$score1}"
    @score2_text.text = "#{$score2}"

#    @eyes1.x = @player1.x - 3
#    @eyes1.y = @player1.y - 12
#    @eyes2.x = @player2.x + 3
#    @eyes2.y = @player2.y - 12

    if @player3 != nil
      if @player3.y > @puck.y && rand(5) == 1
        @player3.go_up
      end
      if @player3.y < @puck.y && rand(5) == 1
        @player3.go_down
      end
    end

    self.game_objects.destroy_if { |object| object.color.alpha == 0 }
  end
end

