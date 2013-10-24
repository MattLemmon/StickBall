
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

