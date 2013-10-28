class Eyes
  def initialize parent
    @parent = parent
    @image = Gosu::Image["players/eye_sockets.png"]
    @eye_ball = Gosu::Image["players/eye_ball.png"]
    @eye_blink = Gosu::Image["players/eye_blink.png"]
    @x = 0
    @y = 0
    @blinking = false
    @blink_count = 0
    @blink_max = 8
    @rand = 8
    @eye_angle = 5
  end
  
  def update
    @x = @parent.x + 3 * @parent.direction
    @y = @parent.y - 7
    puck = @parent.game_state.puck
    @eye_angle = Gosu.angle @x, @y, puck.x, puck.y
    if @blink_count < @blink_max
      @blink_count += 1
    else
      @blink_count = 0
      @blinking = false
      if rand(@rand) == 1
        @blinking = true
      end
    end
  end
  
  def draw
    @image.draw_rot @x, @y, Zorder::Face, 0, 0.5, 1.0
    @eye_ball.draw_rot @x-7+Gosu.offset_x(@eye_angle, 3), @y-2+Gosu.offset_y(@eye_angle, 2), Zorder::Face, 0, 0.5, 1.0
    @eye_ball.draw_rot @x+7+Gosu.offset_x(@eye_angle, 3), @y-2+Gosu.offset_y(@eye_angle, 2), Zorder::Face, 0, 0.5, 1.0
    if @blinking == true
      @eye_blink.draw_rot @x, @y, Zorder::Face, 0, 0.5, 1.0
    end
  end
end



class CloneEyes
  def initialize parent
    @parent = parent
    @image = Gosu::Image["players/eye_sockets.png"]
    @eye_ball = Gosu::Image["players/eye_ball.png"]
    @eye_blink = Gosu::Image["players/eye_blink.png"]
    @x = 0
    @y = 0
    @blinking = false
    @blink_count = 0
    @blink_max = 10
    @rand = 10
    @eye_angle = 5
  end
  
  def update
    @x = @parent.x + 3 * @parent.direction
    @y = @parent.y - 7
    @eye_angle = Gosu.angle @x, @y, @x-10 , @y+10

#    puck = @parent.game_state.puck
#    @eye_angle = Gosu.angle @x, @y, puck.x, puck.y

    if @blink_count < @blink_max
      @blink_count += 1
    else
      @blink_count = 0
      @blinking = false
      if rand(@rand) == 1
        @blinking = true
      end
    end
  end
  
  def draw
    @image.draw_rot @x, @y, Zorder::Face, 0, 0.5, 1.0
    @eye_ball.draw_rot @x-7+Gosu.offset_x(@eye_angle, 3), @y-2+Gosu.offset_y(@eye_angle, 2), Zorder::Face, 0, 0.5, 1.0
    @eye_ball.draw_rot @x+7+Gosu.offset_x(@eye_angle, 3), @y-2+Gosu.offset_y(@eye_angle, 2), Zorder::Face, 0, 0.5, 1.0
    if @blinking == true
      @eye_blink.draw_rot @x, @y, Zorder::Face, 0, 0.5, 1.0
    end
  end
end