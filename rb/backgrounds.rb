#
# BACKGROUND 1
#
class Background1 < Chingu::GameObject
  
  def setup
    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
  
    #
    # If no :zorder is given to @parallax.add_layer it defaults to first added -> lowest zorder
    # Everywhere the :image argument is used, these 2 values are the Same:
    # 1) Image["foo.png"]  2) "foo.png"
    #
    # Notice we add layers to the parallax scroller in 3 different ways. 
    # They all end up as ParallaxLayer-instances internally
    #
    @parallax.add_layer(:image => "backgrounds/space1.png", :damping => 10)
    @parallax.add_layer(:image => "backgrounds/space3.png", :damping => 5)
#    @parallax.add_layer(:image => "layer-cat.png", :x => 0, :y => 460, :damping => -1)
#    @parallax.add_layer(:image => "layer-trees.png", :x => 0,  :y => 610, :damping => 5)
#    @parallax << Chingu::ParallaxLayer.new(:image => "layer-grass.png", :damping => 3, :parallax => @parallax)
#    @parallax << {:image => "layer-sand.png", :damping => 1}
  end


  def camera_left
    @parallax.camera_x -= 2     # This is essentially the same as @parallax.x += 2
  end
    def camera_right
    @parallax.camera_x += 2     # This is essentially the same as @parallax.x -= 2
  end  
  def camera_up
    @parallax.camera_y -= 1     # This is essentially the same as @parallax.y += 2
  end
  def camera_down
    @parallax.camera_y += 1    # This is essentially the same as @parallax.y -= 2
  end

  def update
    camera_right
#    camera_down
  end
end