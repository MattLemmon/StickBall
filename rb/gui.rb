
#
#  GUI1 CLASS             ( RIGHT PLAYER )
#    Health Meter, Star Meter
class GUI1 < Chingu::GameObject
  def initialize
	  super
	  @heart_meter = Gosu::Image.new($window, "./media/gui/heart_meter.png")
#	  @heart_half = Gosu::Image.new($window, "./media/gui/heart_half.png")
#	  @heart_empty = Gosu::Image.new($window, "./media/gui/heart_empty.png")
	  @star_full = Gosu::Image.new($window, "./media/gui/star_full.png")
#	  @star_half = Gosu::Image.new($window, "./media/gui/star_half.png")
	  @star_empty = Gosu::Image.new($window, "./media/gui/star_empty.png")
    @spell_empty = Gosu::Image.new($window, "./media/gui/spell_empty.png")
    @stun = Gosu::Image.new($window, "./media/gui/stun.png")
    @mist = Gosu::Image.new($window, "./media/gui/mist.png")

    @power_ups_text = Chingu::Text.create("Power Ups: #{$power_ups1}", :y => 50, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text.x = 690 - @power_ups_text.width/2
#    @spell_text = Chingu::Text.create("Spell: #{$spell1}", :y => 80, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
#    @spell_text.x = 600 - @spell_text.width/2
#    @hearts = $health1 - 1
  end

  def power_up
    if $power_ups1 == 1
      @power_ups_text.text = "Speed"
      @power_ups_text.x = 690 - @power_ups_text.width/2
    elsif $power_ups1 == 2
      @power_ups_text.text = "Creep"
      @power_ups_text.x = 690 - @power_ups_text.width/2
    else
      @power_ups_text.text = "Bump"
      @power_ups_text.x = 690 - @power_ups_text.width/2
    end
  end

#  def update
#    super
#    @power_ups_text.text = "Power Ups: #{$power_ups1}"
#    @spell_text.text = "Spell: #{$spell1}"
#  end

  def draw
    @heart_meter.draw(@x+738, @y+4, 10)

    for i in 1..5
      @star_empty.draw(@x+730-18*i, @y+15, Zorder::GUI_Bkgrd)
    end
    for i in 1..$stars1
      @star_full.draw(@x+730-18*i, @y+15, Zorder::GUI)
    end

    @spell_empty.draw(@x+610, @y+15, Zorder::GUI_Bkgrd)
    if $spell1 == "stun"
      @stun.draw(@x+610, @y+15, Zorder::GUI)
    end
    if $spell1 == "mist"
      @mist.draw(@x+610, @y+15, Zorder::GUI)
    end
	end
end


#
#  GUI2 CLASS             ( LEFT PLAYER )
#    Health Meter, Star Meter
class GUI2 < Chingu::GameObject
  def initialize
	  super
	  @heart_meter = Gosu::Image.new($window, "./media/gui/heart_meter.png")
#	  @heart_half = Gosu::Image.new($window, "./media/gui/heart_half.png")
#	  @heart_empty = Gosu::Image.new($window, "./media/gui/heart_empty.png")
	  @star_full = Gosu::Image.new($window, "./media/gui/star_full.png")
#	  @star_half = Gosu::Image.new($window, "./media/gui/star_half.png")
	  @star_empty = Gosu::Image.new($window, "./media/gui/star_empty.png")
    @spell_empty = Gosu::Image.new($window, "./media/gui/spell_empty.png")
    @stun = Gosu::Image.new($window, "./media/gui/stun.png")
    @mist = Gosu::Image.new($window, "./media/gui/mist.png")

    @power_ups_text = Chingu::Text.create("Power Ups: #{$power_ups2}", :y => 50, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text.x = 110 - @power_ups_text.width/2

#    @spell_text = Chingu::Text.create("Spell: #{$spell1}", :y => 80, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
#    @spell_text.x = 200 - @spell_text.width/2
#    @hearts = $health2 - 1
  end

  def power_up
    if $power_ups2 == 1
      @power_ups_text.text = "Speed"
      @power_ups_text.x = 110 - @power_ups_text.width/2
    elsif $power_ups2 == 2
      @power_ups_text.text = "Creep"
      @power_ups_text.x = 110 - @power_ups_text.width/2
    else
      @power_ups_text.text = "Bump"
      @power_ups_text.x = 110 - @power_ups_text.width/2
    end
  end

#  def update
#		 super
#    @power_ups_text.text = "Power Ups: #{$power_ups2}"
#    @spell_text.text = "Spell: #{$spell2}"
#	 end

  def draw
    @heart_meter.draw(@x + 10, @y + 4, 10)

    for i in 1..5
      @star_empty.draw(@x+40+18*i, @y+15, Zorder::GUI_Bkgrd)
    end
    for i in 1..$stars2
      @star_full.draw(@x+40+18*i, @y+15, Zorder::GUI)
    end

    @spell_empty.draw(@x+170, @y+15, Zorder::GUI_Bkgrd)
    if $spell2 == "stun"
      @stun.draw(@x+170, @y+15, Zorder::GUI)
    end
    if $spell2 == "mist"
      @mist.draw(@x+170, @y+15, Zorder::GUI)
    end
	end
end

