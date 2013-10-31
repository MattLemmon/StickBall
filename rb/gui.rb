

#
#  GUI1 CLASS             ( RIGHT PLAYER )
#    Health Meter, Star Meter
class GUI1 < Chingu::GameObject
  def initialize
	  super
	  @heart_meter = Gosu::Image.new($window, "./media/gui/heart_meter.png")
    @score_box = Gosu::Image.new($window, "./media/gui/score_box.png")
	  @star_full = Gosu::Image.new($window, "./media/gui/star_full.png")
	  @star_empty = Gosu::Image.new($window, "./media/gui/star_empty.png")
    @spell_empty = Gosu::Image.new($window, "./media/gui/spell_empty.png")
    @stun = Gosu::Image.new($window, "./media/gui/stun.png")
    @mist = Gosu::Image.new($window, "./media/gui/mist.png")

    @text_pos_x = 684

    @power_ups_text1 = Chingu::Text.create("", :y => 42, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2

    @power_ups_text2 = Chingu::Text.create("", :y => 63, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2

    @power_ups_text3 = Chingu::Text.create("", :y => 86, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2

    if $power_ups1 > 0
      @power_ups_text1.text = "Speed"
      @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2
    end
    if $power_ups1 > 1
      @power_ups_text2.text = "Bump"
      @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2
    end
    if $power_ups1 > 2
      @power_ups_text3.text = "Kick"
      @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2
    end
  end

  def power_up
    if $power_ups1 == 1
      @power_ups_text1.text = "Speed"
      @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2
    elsif $power_ups1 == 2
      @power_ups_text2.text = "Bump"
      @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2
    else
      @power_ups_text3.text = "Kick"
      @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2
    end
  end

#  def update
#    super
#    @timer_text.text = "Timer: #{milliseconds % 30}"
#    @timer_text.x = @x + @timer_pos_x - @timer_text.width/2
#    @timer_text.y = @y + @timer_pos_y
#  end

  def draw
    @heart_meter.draw(@x+738, @y+4, 10)
    @score_box.draw(@x+473, @y+4, 10)

    for i in 1..5
      @star_empty.draw(@x+730-22*i, @y+15, Zorder::GUI_Bkgrd)
    end
    for i in 1..$stars1
      @star_full.draw(@x+730-22*i, @y+15, Zorder::GUI)
    end

    @spell_empty.draw(@x+593, @y+15, Zorder::GUI_Bkgrd)
    if $spell1 == "stun"
      @stun.draw(@x+593, @y+15, Zorder::GUI)
    end
    if $spell1 == "mist"
      @mist.draw(@x+593, @y+15, Zorder::GUI)
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
    @score_box = Gosu::Image.new($window, "./media/gui/score_box.png")
	  @star_full = Gosu::Image.new($window, "./media/gui/star_full.png")
	  @star_empty = Gosu::Image.new($window, "./media/gui/star_empty.png")
    @spell_empty = Gosu::Image.new($window, "./media/gui/spell_empty.png")
    @stun = Gosu::Image.new($window, "./media/gui/stun.png")
    @mist = Gosu::Image.new($window, "./media/gui/mist.png")

#    @power_ups_text = Chingu::Text.create("Power Ups: #{$power_ups2}", :y => 50, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
#    @power_ups_text.x = 110 - @power_ups_text.width/2

    @text_pos_x = 116

    @power_ups_text1 = Chingu::Text.create("", :y => 42, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2

    @power_ups_text2 = Chingu::Text.create("", :y => 63, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2

    @power_ups_text3 = Chingu::Text.create("", :y => 86, :font => "GeosansLight", :size => 26, :color => Colors::White, :zorder => Zorder::GUI)
    @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2

    if $power_ups2 > 0
      @power_ups_text1.text = "Speed"
      @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2
    end
    if $power_ups2 > 1
      @power_ups_text2.text = "Bump"
      @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2
    end
    if $power_ups2 > 2
      @power_ups_text3.text = "Kick"
      @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2
    end
  end

  def power_up
    if $power_ups2 == 1
      @power_ups_text1.text = "Speed"
      @power_ups_text1.x = @text_pos_x - @power_ups_text1.width/2
    elsif $power_ups2 == 2
      @power_ups_text2.text = "Bump"
      @power_ups_text2.x = @text_pos_x - @power_ups_text2.width/2
    else
      @power_ups_text3.text = "Kick"
      @power_ups_text3.x = @text_pos_x - @power_ups_text3.width/2
    end
  end

  def draw
    @heart_meter.draw(@x + 10, @y + 4, 10)
    @score_box.draw(@x+273, @y+4, 10)

    for i in 1..5
      @star_empty.draw(@x+41+22*i, @y+15, Zorder::GUI_Bkgrd)
    end
    for i in 1..$stars2
      @star_full.draw(@x+41+22*i, @y+15, Zorder::GUI)
    end

    @spell_empty.draw(@x+178, @y+15, Zorder::GUI_Bkgrd)
    if $spell2 == "stun"
      @stun.draw(@x+178, @y+15, Zorder::GUI)
    end
    if $spell2 == "mist"
      @mist.draw(@x+178, @y+15, Zorder::GUI)
    end
	end
end


=begin  def power_up
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
=end

#  def update
#    super
#    @power_ups_text.text = "Power Ups: #{$power_ups2}"
#    @spell_text.text = "Spell: #{$spell2}"
#  end
