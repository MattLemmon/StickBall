
  # Characters Class
  def setup
    #...
    #@yy           = rand() ** 4.0
    @yy           = rand() ** 2.0
    @xx           = rand()

    @offset_x = 0
    @offset_y = 30

    # self.y = rand() ** 4.0 * 130 + 350
    #self.factor = (@y-300)/300.0  # character size is affected by y position
    #self.factor = 0.7
    self.factor = @yy * 0.7 + 0.4
    #self.zorder = self.factor.abs * 400
    self.zorder = @yy * 300
    #col = ((self.factor) * 2.0) ** 2.0 * 255
    # self.x = rand(self.factor * 800) + (1.0 - self.factor) * 500
  end

  # Field Gamestate collision_detection
    FireCube.each do |particle|             # SCORING AND WALL-BOUNCING  SCORING  SCORING
      if @bounce == 0
        if particle.x < 0
          particle.x = 0
          particle.velocity_x = -particle.velocity_x
#          $score1 += 1
          $bang2.play(0.3)
          if $health2 > 1
            $health2 -=1
            @health2_text.text = "#{$health2}"
            @health2_text.x = 38 - @health2_text.width/2
          elsif $round < 3
            $round += 1
            $score1 += 1
            @round_text.text = "Round #{$round}"
            @round_text.x = 400 - @round_text.width/2
            puts "round #{$round}"
            puts "score1 #{$score1}"
            puts "score2 #{$score2}"
#            next_round
            push_game_state(FieldChange)
          else
            $score1 += 1
            $winner = "right player"
            $round = 1
            push_game_state(GameOver)
          end
          particle.die!
          screen_shake1
          @referee.update_face
          @player1.update_face
          @player2.update_face
          @bounce = @bounce_delay
        end
        if particle.x > $window.width
          particle.x = $window.width
          particle.velocity_x = -particle.velocity_x
#          $score2 += 1
          $bang1.play(0.4)
          if $health1 > 1
            $health1 -=1
            @health1_text.text = "#{$health1}"
            @health1_text.x = 765 - @health1_text.width/2
          elsif $round < 3
            $round += 1
            $score2 += 1
            @round_text.text = "Round #{$round}"
            @round_text.x = 400 - @round_text.width/2
            puts "round #{$round}"
            puts "score1 #{$score1}"
            puts "score2 #{$score2}"
            push_game_state(FieldChange)
          else
            $score2 += 1
            $winner = "left player"
            $round = 1
            push_game_state(GameOver)
          end
          particle.die!
          screen_shake2
          @referee.update_face
          @player1.update_face
          @player2.update_face
          @bounce = @bounce_delay
        end
        if particle.y < 0
          particle.y = 0
          particle.velocity_y = -particle.velocity_y
          particle.die!
          @bounce = @bounce_delay
        end
        if particle.y > $window.height
          particle.y = $window.height
          particle.velocity_y = -particle.velocity_y
          particle.die!
          @bounce = @bounce_delay
        end
      end
    end








MSG TO Weezard:

Hey thanks a lot! We're getting pretty close to the deadline. I don't know exactly what language I would say everything is in - Chingu I guess would be the closest answer. I'm not sure what runs under the hood of Gosu, but I think it pulls together functionality from C++ and other frameworks, and then just makes it accessible in Ruby for people like me who don't know anything about C++. We're possibly going to include a gl shader (using the ashton gem), but that may get left out in the final draft.

Ya, I'm feeling pretty good about it, although there are still a ton of loose ends to tie up. Pretty decent for less than two weeks start to finish. A lot of the professional touches that make it look crisp and polished come from the other team members. I have little to no understanding of how the lense flares work but they look fantastic!





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

