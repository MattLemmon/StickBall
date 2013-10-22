
#
#  GUI1 CLASS             ( RIGHT PLAYER )
#    Health Meter, Star Meter
class GUI1 < Chingu::GameObject
  def initialize
	  super
	  @heart_full = Gosu::Image.new($window, "./media/gui/heart.png")
	  @heart_half = Gosu::Image.new($window, "./media/gui/heart_half.png")
	  @heart_empty = Gosu::Image.new($window, "./media/gui/heart_empty.png")
	  @star_full = Gosu::Image.new($window, "./media/gui/star_full.png")
	  @star_half = Gosu::Image.new($window, "./media/gui/star_half.png")
	  @star_empty = Gosu::Image.new($window, "./media/gui/star_empty.png")

    @score_text = Chingu::Text.create("Power Ups: #{$power_ups1}", :y => 50, :font => "GeosansLight", :size => 20, :color => Colors::White, :zorder => Zorder::GUI)
    @score_text.x = 500 - @score_text.width/2
  end

  def update
    super
    @score_text.text = "Power Ups: #{$power_ups1}"
  end

  def draw      # draw health meter and star meter according to $health and $stars
    for i in 0..5
      @heart_empty.draw(18*i+680, 0, Zorder::GUI_Bkgrd)
    end
    for i in 0..$health1 - 1
      @heart_full.draw(18*i+680, 0, Zorder::GUI)
    end

    for i in 0..2
      @star_empty.draw(18*i+740, 20, Zorder::GUI)
    end
    for i in 0..$stars1 - 1
      @star_full.draw(18*i+740, 20, Zorder::GUI)
    end
	end
end


#
#  GUI2 CLASS             ( LEFT PLAYER )
#    Health Meter, Star Meter
class GUI2 < Chingu::GameObject
  def initialize
	  super
	  @heart_full = Gosu::Image.new($window, "./media/gui/heart.png")
	  @heart_half = Gosu::Image.new($window, "./media/gui/heart_half.png")
	  @heart_empty = Gosu::Image.new($window, "./media/gui/heart_empty.png")
	  @star_full = Gosu::Image.new($window, "./media/gui/star_full.png")
	  @star_half = Gosu::Image.new($window, "./media/gui/star_half.png")
	  @star_empty = Gosu::Image.new($window, "./media/gui/star_empty.png")

    @score_text = Chingu::Text.create("Power Ups: #{$power_ups2}", :y => 50, :font => "GeosansLight", :size => 20, :color => Colors::White, :zorder => Zorder::GUI)
    @score_text.x = 300 - @score_text.width/2
  end

  def update
		 super
		 @score_text.text = "Power Ups: #{$power_ups2}"
	 end

  def draw      # draw health meter and star meter according to $health and $stars
    for i in 0..5
      @heart_empty.draw(18*i+2, 0, Zorder::GUI_Bkgrd)
    end
    for i in 0..$health2 - 1
      @heart_full.draw(18*i+2, 0, Zorder::GUI)
    end

    for i in 0..2
      @star_empty.draw(18*i+2, 20, Zorder::GUI_Bkgrd)
    end
    for i in 0..$stars2 - 1
      @star_full.draw(18*i+2, 20, Zorder::GUI)
    end
	end
end





