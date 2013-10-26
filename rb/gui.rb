
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

    @power_ups_text = Chingu::Text.create("Power Ups: #{$power_ups1}", :y => 50, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text.x = 600 - @power_ups_text.width/2
    @spell_text = Chingu::Text.create("Spell: #{$spell1}", :y => 80, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @spell_text.x = 600 - @spell_text.width/2

    @hearts = $health1 - 1
  end

  def update
    super
    @power_ups_text.text = "Power Ups: #{$power_ups1}"
    @spell_text.text = "Spell: #{$spell1}"

  end

  def draw      # draw health meter and star meter according to $health and $stars
    for i in 0..@hearts
      @heart_empty.draw(782-18*i, 0, Zorder::GUI_Bkgrd)
    end
    for i in 0..$health1 - 1
      @heart_full.draw(782-18*i, 0, Zorder::GUI)
    end

    for i in 0..4
      @star_empty.draw(782-18*i, 20, Zorder::GUI)
    end
    for i in 0..$stars1 - 1
      @star_full.draw(782-18*i, 20, Zorder::GUI)
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

    @power_ups_text = Chingu::Text.create("Power Ups: #{$power_ups2}", :y => 50, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text.x = 200 - @power_ups_text.width/2

    @spell_text = Chingu::Text.create("Spell: #{$spell1}", :y => 80, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @spell_text.x = 200 - @spell_text.width/2
    @hearts = $health2 - 1
  end

  def update
		 super
    @power_ups_text.text = "Power Ups: #{$power_ups2}"
    @spell_text.text = "Spell: #{$spell2}"
	 end

  def draw      # draw health meter and star meter according to $health and $stars
    for i in 0..@hearts
      @heart_empty.draw(18*i+2, 0, Zorder::GUI_Bkgrd)
    end
    for i in 0..$health2 - 1
      @heart_full.draw(18*i+2, 0, Zorder::GUI)
    end

    for i in 0..4
      @star_empty.draw(18*i+2, 20, Zorder::GUI_Bkgrd)
    end
    for i in 0..$stars2 - 1
      @star_full.draw(18*i+2, 20, Zorder::GUI)
    end
	end
end





