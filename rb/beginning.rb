
#
#  BEGINNING GAMESTATE
#    this gamestate essentially just plays the opening music and pushes the OpeningCredits gamestate
class Beginning < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit,  [:right_shift, :left_shift] => OpeningCredits } #, :p => Pause, :r => lambda{current_game_state.setup} }
    $music = Song["audio/guitar_solo.ogg"]
    $music.volume = 0.6
    after(2) { $music.play(true) }
    after(4) { push_game_state(PreIntro) }#Chingu::GameStates::FadeTo.new(PreIntro.new, :speed => 20)) }
  end
end


#
#  PRE-INTRO GAMESTATE
#
class PreIntro < Chingu::GameState
  trait :timer
  def initialize
    super
    LenseFlares.load_images $window, './media/lense_flares'
    @lense_flares = LenseFlares.new $window.width/2.0, $window.height/2.0
    self.input = { [:left_shift, :right_shift] => :next, :p => Pause } #, :r => lambda{current_game_state.setup} } [:up, :down, :w, :s] => :cpu_difficulty,
  end

  def setup
    ####################################################
    $difficulty = "Normal"
    $score1 = 0
    $score2 = 0
    $mode = "Versus"
    $image1 = "boy"
    $image2 = "boy"
    $round = 1
    $pos1_x, $pos1_y = 740, 300
    $pos2_x, $pos2_y = 60, 300
    $stars1 = 0
    $stars2 = 0
    $speed1 = 6
    $speed2 = 6
    $power_ups1 = 0
    $power_ups2 = 0
    $creep1 = false
    $creep2 = false
    $chest_bump1 = false
    $chest_bump2 = false
    $kick1 = false
    $kick2 = false
    $spell1 = "none"
    $spell2 = "none"
    ####################################################
    Chingu::Text.destroy_all 
    $window.caption = "StickBall"
    @ground_y = ($window.height * 0.95).to_i
    @nxt = false
    @song_fade = false
    @fade_count = 0
    @bounce = 0
    @bounce_delay = 6

#    @counter = 0  
#    @count = 1    

    if $intro == false
      $music = Song["media/audio/guitar_solo.ogg"]
      $music.volume = 0.8
      $music.play(true)
    else
      $intro = false
    end

    @title = Title.create

    after(300) {
    @t1 = Chingu::Text.create("Right Player", :y => 300, :font => "GeosansBold", :size => 52, :color => Colors::White, :zorder => Zorder::GUI)
    @t1.x = 600 - @t1.width/2 # center text
    @t2 = Chingu::Text.create("Left Player", :y => 300, :font => "GeosansBold", :size => 52, :color => Colors::White, :zorder => Zorder::GUI)
    @t2.x = 200 - @t2.width/2 # center text
    }

    after(600) {
      @mode_select = ModeSelect.create
      @mode_select.input = { [:right, :left,  :a, :d ] => :mode_select, [:up, :w] => :go_up, [:down, :s] => :go_down }
      @t3 = Chingu::Text.create("Arrows", :y => 370, :size => 40, :font => "GeosansBold", :zorder => Zorder::GUI)
      @t3.x = 600 - @t3.width/2 # center text
      @text5 = Chingu::Text.create("Right Shift", :y => 430, :size => 38, :zorder => Zorder::GUI)
      @text5.x = 600 - @text5.width/2 # center text
      @text6 = Chingu::Text.create("Right Ctrl", :y => 490, :size => 38, :zorder => Zorder::GUI)
      @text6.x = 600 - @text6.width/2 # center text

    }

    after(1500) {
      1.times { new_puck }
#      @puck = FireCube.create(:x => rand(550), :y => rand(600), :zorder => Zorder::Projectile)
#      @puck_flare = @lense_flares.create @puck.x, @puck.y, Zorder::LenseFlare
#      @puck_flare.brightness = 0.25
#      @puck_flare.strength = 0.3
#      @puck_flare.scale = 1.0
    }
  end

  def new_puck
    @puck = FireCube.create(:x => rand(550), :y => rand(600), :zorder => Zorder::Projectile)
    @puck_flare = @lense_flares.create @puck.x, @puck.y, Zorder::LenseFlare
    @puck_flare.brightness = 0.25
    @puck_flare.strength = 0.3
    @puck_flare.scale = 1.0
  end

  def next
    if @nxt == true  # if you've already pressed 'shift' once, pressing it again skips ahead
 
#      $difficulty = "Normal"

      @nxt = false
      $click.play(0.7)
      push_game_state(Intro)
    else
      @nxt = true    # transition to Intro
      $chime.play(0.7)
#      after(300) { puts 1 }
#      after(600) { puts 2 }
      after(200) { push_game_state(Intro) }
    end
  end

  def update
#    @counter += @count
    if @bounce > 0
      @bounce -= 1
    end
    if @puck != nil
      @puck_flare.x = @puck.x
      @puck_flare.y = @puck.y
      @puck_flare.color = @puck.color
      @lense_flares.update
    end
    super
    FireCube.each do |particle|   # WALL-BOUNCING 
      if @bounce == 0
        if particle.x < 0
          particle.x = 0
          particle.velocity_x = -particle.velocity_x
          particle.die!
          @bounce = @bounce_delay
        end
        if particle.x > $window.width
          particle.x = $window.width
          particle.velocity_x = -particle.velocity_x
          particle.die!
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

    self.game_objects.destroy_if { |object| object.color.alpha == 0 }

    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 20
        @fade_count = 0
        $music.volume -= 0.1
      end
    end
  end

  def draw
    @lense_flares.draw
    fill_gradient(:from => Color.new(255,0,0,0), :to => Color.new(255,60,60,80), :rect => [0,0,$window.width,@ground_y])
    fill_gradient(:from => Color.new(255,100,100,100), :to => Color.new(255,50,50,50), :rect => [0,@ground_y,$window.width,$window.height-@ground_y])
    super
  end
end






#
#  INTRO GAMESTATE
#
class Intro < Chingu::GameState
  trait :timer
  def setup

    $health1 = 10
    $health2 = 10
    $start_health1 = 10
    $start_health2 = 10
    $window.caption = "StickBall"

    @counter = 0  
    @count = 1    
    @transition = false
    @next = false
    @song_fade = false
    @fade_count = 0
    @chant = "Prepare for Battle"

    if $mode == "Versus"
      @health2_text1 = "Health"
      @health2_text2 = $health2.to_s
      self.input = { :p => Pause,           # [:enter, :return] => FieldChange,
                    :right_shift => :ready1,
                    :left_shift => :ready2 }
    else
      self.input = { :right_shift => :ready1 , :p => Pause } #, :r => lambda{current_game_state.setup} }
      @health2_text1 = ""
      @health2_text2 = ""
    end

    Chingu::Text.destroy_all 
    CharWheel1.destroy_all
    CharWheel2.destroy_all

    after(600) {
      @player1_select = CharWheel1.create(:x => 550, :y => 300, :zorder => Zorder::Main_Character)
      @player1_select.input = { :right => :go_right, :left => :go_left,
                              :up => :go_up, :down => :go_down}
      @ready1 = false
      @caption1 = Chingu::Text.create("#{$image1}", :y => @player1_select.y - 150, :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
      @caption1.x = @player1_select.x - @caption1.width/2 # center text
    }
    after(900) {
      @player2_select = CharWheel2.create(:x => 250, :y => 300, :zorder => Zorder::Main_Character)
      if $mode == "Versus"
        @player2_select.input = {:a => :go_left, :d => :go_right, :w => :go_up, :s => :go_down}
      end
      @ready2 = false

      @caption2 = Chingu::Text.create("#{$image2}", :y => @player2_select.y - 150, :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
      @caption2.x = @player2_select.x - @caption2.width/2 # center text
    }

    after(1200) {
      @text3 = Chingu::Text.create("Health", :y => 300, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text3.x = 714 - @text3.width/2 # center text
      @text3_5 = Chingu::Text.create( $health1.to_s, :y => 270, :size => 40, :color => Colors::White, :zorder => Zorder::GUI)
      @text3_5.x = 714 - @text3_5.width/2 # center text
    }
    after(1500) {
      @text4 = Chingu::Text.create("#{@health2_text1}", :y => 300, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text4.x = 107 - @text4.width/2 # center text
      @text4_5 = Chingu::Text.create("#{@health2_text2}", :y => 270, :size => 40, :color => Colors::White, :zorder => Zorder::GUI)
      @text4_5.x = 107 - @text4_5.width/2 # center text
    }
    after(1800) {
      @text1 = Chingu::Text.create("Right Shift", :y => 420, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text1.x = 614 - @text1.width/2 # center text
      @text1_5 = Chingu::Text.create("to Select", :y => 452, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text1_5.x = 614 - @text1_5.width/2 # center text
    }
    after(2100) {
      if $mode == "Versus"
        @text2 = Chingu::Text.create("Left Shift", :y => 420, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
        @text2.x = 207 - @text2.width/2 # center text
        @text2_5 = Chingu::Text.create("to Select", :y => 452, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
        @text2_5.x = 207 - @text2_5.width/2 # center text
      end
    }
    if $mode == "Campaign"
      cpu_select_character
    end
  end

  def ready1
    if @ready1 == false
      @ready1 = true
      if @player1_select != nil
        @player1_select.ready
      end
      #puts "ready"
      $chime_right.play(0.7)
      after(800) { if @text1_5 != nil; @text1_5.destroy; end }
      after(1600) { if @text1 != nil; @text1.destroy; end }
    elsif @ready2 == true
      push_game_state(FieldChange)
    end
  end

  def ready2
    if @ready2 == false
      @ready2 = true
      if @player2_select != nil
        @player2_select.ready
      end
      #puts "ready"
      $chime_left.play(0.7)
      after(800) { if @text2_5 != nil; @text2_5.destroy; end }
      after(1600) { if @text2 != nil; @text2.destroy; end }
    elsif @ready1 == true
      push_game_state(FieldChange)
    end
  end

  def cpu_select_character
    after(1200) { if rand(2) == 1; @player2_select.go_right; end }
    after(1400) { if rand(2) == 1; @player2_select.go_right; end }
    after(1600) { if rand(2) == 1; @player2_select.go_right; end }
    after(1800) { if rand(2) == 1; @player2_select.go_right; end }
    after(2000) { if rand(2) == 1; @player2_select.go_right; end }
    after(2200) { if rand(2) == 1; @player2_select.go_right; end }
    after(2400) { if rand(2) == 1; @player2_select.go_right; end }
    after(2600) { if rand(2) == 1; @player2_select.go_right; end }
    after(2800) { if rand(2) == 1; @player2_select.go_right; end }
    after(2900) { if rand(2) == 1; @player2_select.go_right; end }
    after(3000) { if rand(2) == 1; @player2_select.go_right; end }
    after(3100) { if rand(2) == 1; @player2_select.go_right; end }
    after(3200) { if rand(2) == 1; @player2_select.go_right; end }
    after(3300) { if rand(2) == 1; @player2_select.go_right; end }
    after(3500) { if rand(2) == 1; @player2_select.go_right; end }
    after(3800) { if rand(2) == 1; @player2_select.go_right; end }
    after(4100) { ready2 }
  end

  def update
    super
    @counter += @count
    if @caption1 != nil
      @caption1.text = $image1
      @caption1.x = @player1_select.x - @caption1.width/2 # center text
    end
    if @caption2 != nil
      @caption2.text = $image2
      @caption2.x = @player2_select.x - @caption2.width/2 # center text
    end
    if @text3_5 != nil
      @text3_5.text = $health1.to_s
      @text3_5.x = 714 - @text3_5.width/2 # center text
    end
    if $mode == "Versus"
      if @text4_5 != nil
        @text4_5.text = $health2.to_s
        @text4_5.x = 107 - @text4_5.width/2 # center text
      end
    end

    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 50
        @fade_count = 0
        $music.volume -= 0.1
      end
    end

    if @ready1 == true && @ready2 == true
      if @transition == false
        transition
      end
    end
  end

  def transition
    @transition = true
    after(40) { $guitar_fill.play(0.4) }

    after(100) { $music.volume = 0.3 }
#    @song_fade = true
#    after(100) { $guitar_fill.play(0.4) }s
    after(410) {
#      @song_fade = false
      $music = Song["media/audio/guitar_riff.ogg"]
      $music.volume = 0.4
      $music.play(false)
    }
#      @song_fade = true
#      $guitar_riff.play(0.4) }
    after(1500) {
      @text3 = Chingu::Text.create("#{@chant}", :y => 50, :size => 60, :color => Colors::White, :zorder => Zorder::GUI)
      @text3.x = 400 - @text3.width/2 }
    after(2000) { @text3.text = "" }
    after(2400) { @text3.text = "#{@chant}" }
    after(2800) { @text3.text = "" }
    after(3200) { @text3.text = "#{@chant}" }
    after(3600) { @text3.text = "" }
    after(4000) { @text3.text = "#{@chant}" }
    after(4400) { @text3.text = "" }
    after(4800) { @text3.text = "#{@chant}" }
    after(5200) { @text3.text = "" }
    after(6500) {
      push_game_state(FieldChange)
    }
  end
end




#
#  OPENING CREDITS GAMESTATE
#    Gosu logo with animated highlights 
class OpeningCredits < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => :intro, :p => Pause, :r => lambda{current_game_state.setup} }
    @beam = Highlight.create(:x => 66, :y => 300)  # Highlights are defined in objects.rb
    @beam2 = Highlight2.create(:x => 0, :y => 300)
    @beam3 = Highlight.create(:x => -500, :y => 300)
    after (3900) {
      push_game_state(Chingu::GameStates::FadeTo.new(OpeningCredits2.new, :speed => 8))
    }
  end

  def intro # pressing 'enter' skips ahead to the Introduction
    push_game_state(Chingu::GameStates::FadeTo.new(PreIntro.new, :speed => 11))
  end

  def draw
    Image["objects/gosu-logo.png"].draw(0, 0, 0)
    super
  end
end

#
#  OPENING CREDITS 2 GAMESTATE
#    Ruby logo with animated sparkle
class OpeningCredits2 < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit, [:enter, :return] => :intro, :p => Pause, :r => lambda{current_game_state.setup} }
    Sparkle.destroy_all
    @sparkle = Sparkle.create(:x => 373, :y => 301, :zorder => 20) # Sparkle is defined in objects.rb
    after(20) { @sparkle.turnify1 }
    after(120) { @sparkle.turnify2 }
    after(500) { @sparkle.turnify3 }
    after(900) { @sparkle.turnify4 }
    after(1900) { @sparkle.turnify5 }
    after(2200) { @sparkle.turnify6 }
    after (2400) { push_game_state(Chingu::GameStates::FadeTo.new(PreIntro.new, :speed => 8)) }
  end
  def intro # pressing 'enter' skips ahead to the Introduction
    push_game_state(Chingu::GameStates::FadeTo.new(PreIntro.new, :speed => 11))
  end
  def draw
    Image["objects/ruby-logo.png"].draw(0, 0, 0)
    super
  end
end



