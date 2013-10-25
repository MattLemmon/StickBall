#
# BACKGROUND 1
#
class Background1 < Chingu::GameObject
  
  def setup
    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
    @parallax.add_layer(:image => "backgrounds/space1.png", :damping => 16)
    @parallax.add_layer(:image => "backgrounds/space2.png", :damping => 12)
    @parallax.add_layer(:image => "backgrounds/space3.png", :damping => 8)
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