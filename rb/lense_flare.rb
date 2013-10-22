class LenseFlares::LenseFlare
  attr_accessor :x, :y, :z, :color, :scale, :brightness, :strength, :flickering
  
  def initialize parent, x, y, z
    @parent = parent
    @x = x
    @y = y
    @z = z
    @scale = 1
    @color = Gosu::Color.rgba        0,   0, 255, 255
    @base_color = Gosu::Color.rgba 255, 255, 255, 255
    @rainbow_flare_color = Gosu::Color.rgba 255, 255, 255, 80
    @flickering = 0.0
    @brightness = 1
    @strength = 0.5
  end
  
  def update
    update_colors
  end
  
  def update_colors
    brightness = @brightness
   
    brightness += (rand-0.5) * @flickering
    brightness = 0 if brightness < 0
    brightness = 1 if brightness > 1
    
    @base_color.alpha         = brightness * 255
    @color     .alpha         = brightness * 255
    @rainbow_flare_color.alpha = brightness * 70
  end

  def draw
    draw_horizontal_flare
    draw_star_flare
    
    dx =  @parent.center_x - @x
    dy =  @parent.center_y - @y
    
    draw_hexagon dx, dy, @scale
    draw_hexagon dx*1.5, dy*1.5, @scale*1.5
    draw_blurred_circle dx*0.6, dy*0.6
    draw_rainbow_flare dx*0.8, dy*0.8
    draw_rainbow_edge dx, dy
  end
  
  def draw_horizontal_flare
    @@horizontal_flare.draw_rot @x, @y, @z, 0, 0.5, 0.5, @scale*@strength,      @scale,           @color,      :additive
    @@horizontal_flare.draw_rot @x, @y, @z, 0, 0.5, 0.5, @scale*@strength**1.5, @scale*@strength, @base_color, :additive
  end
  
  def draw_star_flare
    @@star_flare.draw_rot @x, @y, @z, 0, 0.5, 0.5, @scale*2.0, @scale*2.0, @color, :additive
  end
  
  def draw_hexagon dx, dy, scale
    opposite_x = @parent.center_x + dx 
    opposite_y = @parent.center_y + dy
    @@blurred_hexagon.draw_rot opposite_x, opposite_y, @z, 0, 0.5, 0.5, scale, scale, @color, :additive
  end
  
  def draw_blurred_circle dx, dy
    opposite_x = @parent.center_x + dx
    opposite_y = @parent.center_y + dy
    scale = @scale*@strength
    @@blurred_circle.draw_rot opposite_x, opposite_y, @z, 0, 0.5, 0.5, scale, scale, @color, :additive
  end
  
  def draw_rainbow_flare dx, dy
    scale = @scale * 1.2
    angle = Gosu.angle(@x, @y, @parent.center_x, @parent.center_y)
    @@rainbow_flare_circle.draw_rot @parent.center_x+dx, @parent.center_y+dy, @z, angle, 0.5, 0.5, scale, scale, @rainbow_flare_color, :additive
  end
  
  def draw_rainbow_edge dx, dy
    angle = Gosu.angle dx, dy, 0, 0
    length = Math.sqrt(dx**2 + dy**2)
    x = -(dx / length * @parent.center_y * 0.8) + @parent.center_x
    y = -(dy / length * @parent.center_y * 0.8) + @parent.center_y
    @@rainbow_flare_edge.draw_rot x, y, @z, angle, 0.5, 0.5, 1.0, 1.0, @rainbow_flare_color, :additive
  end
  
  def self.load_images window, load_path
    @@star_flare           = Gosu::Image.new window, File.join(load_path, 'star_flare.png')
    @@horizontal_flare     = Gosu::Image.new window, File.join(load_path, 'horizontal_flare.png')
    @@blurred_circle       = Gosu::Image.new window, File.join(load_path, 'blurred_circle.png')
    @@blurred_hexagon      = Gosu::Image.new window, File.join(load_path, 'blurred_hexagon.png')
    @@rainbow_flare_circle = Gosu::Image.new window, File.join(load_path, 'rainbow_flare_circle.png')
    @@rainbow_flare_edge   = Gosu::Image.new window, File.join(load_path, 'rainbow_flare_edge.png')
  end
end