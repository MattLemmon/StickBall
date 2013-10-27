
#
#  BEGINNING GAMESTATE
#    this gamestate essentially just plays the opening music and pushes the OpeningCredits gamestate
class Beginning < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit,  [:right_shift, :left_shift] => OpeningCredits } #, :p => Pause, :r => lambda{current_game_state.setup} }
    $music = Song["audio/guitar_solo.ogg"]
    $music.volume = 0.6
    after(5) { $music.play(true) }
    after(5) { push_game_state(PreIntro) }#Chingu::GameStates::FadeTo.new(PreIntro.new, :speed => 20)) }
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
    $window.caption = "StickBall"

    @counter = 0  
    @count = 1    
    @transition = false
    @next = false
    @song_fade = false
    @fade_count = 0
    @chant = "Prepare for Battle"

    if $mode == "Versus"
      self.input = { [:enter, :return] => Field, :p => Pause,
                    :right_shift => :ready1,
                    :left_shift => :ready2 }
    else
      self.input = { :right_shift => :ready1 , :p => Pause } #, :r => lambda{current_game_state.setup} }
    end

    Chingu::Text.destroy_all 
    CharWheel1.destroy_all
    CharWheel2.destroy_all

    transition1

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
      @text4 = Chingu::Text.create("Health", :y => 300, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text4.x = 107 - @text4.width/2 # center text
      @text4_5 = Chingu::Text.create( $health2.to_s, :y => 270, :size => 40, :color => Colors::White, :zorder => Zorder::GUI)
      @text4_5.x = 107 - @text4_5.width/2 # center text
    }
    after(1800) {
      @text1 = Chingu::Text.create("Right Shift", :y => 420, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text1.x = 614 - @text1.width/2 # center text
      @text1_5 = Chingu::Text.create("to Select", :y => 452, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text1_5.x = 614 - @text1_5.width/2 # center text
    }
    after(2100) {
      @text2 = Chingu::Text.create("Left Shift", :y => 420, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text2.x = 207 - @text2.width/2 # center text
      @text2_5 = Chingu::Text.create("to Select", :y => 452, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text2_5.x = 207 - @text2_5.width/2 # center text
    }
    if $mode == "Campaign"
      cpu_select_character
    end
  end

  def ready1
    @ready1 = true
    if @player1_select != nil
      @player1_select.ready
    end
    puts "ready"
    $chime_right.play
    after(800) { if @text1_5 != nil; @text1_5.destroy; end }
    after(1600) { if @text1 != nil; @text1.destroy; end }
  end

  def ready2
    @ready2 = true
    if @player2_select != nil
      @player2_select.ready
    end
    puts "ready"
    $chime_left.play
    after(800) { if @text2_5 != nil; @text2_5.destroy; end }
    after(1600) { if @text2 != nil; @text2.destroy; end }
  end

  def next
    if @nxt == true  # if you've already pressed 'shift' once, pressing it again skips ahead
      @nxt = false
      $click.play
      push_game_state(Intro)
    else
      @nxt = true    # transition to Intro
      $click.play
      after(300) { puts 1 }
      after(600) { puts 2 }
      after(1000) { push_game_state(Intro) }
    end
  end

  def cpu_select_character
    after(2200) { if rand(2) == 1; @player2_select.go_right; end }
    after(2400) { if rand(2) == 1; @player2_select.go_right; end }
    after(2600) { if rand(2) == 1; @player2_select.go_right; end }
    after(2800) { if rand(2) == 1; @player2_select.go_right; end }
    after(3000) { if rand(2) == 1; @player2_select.go_right; end }
    after(3200) { if rand(2) == 1; @player2_select.go_right; end }
    after(3400) { if rand(2) == 1; @player2_select.go_right; end }
    after(3600) { if rand(2) == 1; @player2_select.go_right; end }
    after(3800) { if rand(2) == 1; @player2_select.go_right; end }
    after(4000) { if rand(2) == 1; @player2_select.go_right; end }
    after(4200) { if rand(2) == 1; @player2_select.go_right; end }
    after(4400) { if rand(2) == 1; @player2_select.go_right; end }
    after(4600) { if rand(2) == 1; @player2_select.go_right; end }
    after(4800) { if rand(2) == 1; @player2_select.go_right; end }
    after(5000) { if rand(2) == 1; @player2_select.go_right; end }
    after(5200) { if rand(2) == 1; @player2_select.go_right; end }
    after(5500) { ready2 }
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
    if @text4_5 != nil
      @text4_5.text = $health2.to_s
      @text4_5.x = 107 - @text4_5.width/2 # center text
    end


    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 7
        @fade_count = 0
        $music1.volume -= 0.1
      end
    end

    if @ready1 == true && @ready2 == true
      if @transition == false
        transition2
      end
    end
  end

  def transition1
    puts "Opponent Selection Needed (CPU or PL2)"
#    transition2
  end

  def transition2
    @transition = true
     after(400) {
      @song_fade = true
      $guitar_riff.play(0.4) }
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
    after(5500) {
      $music1.stop
#          @song_fade = false
#          $music2.volume = 0.9
#          $music2.play
#          $music1.volume = 0.9
#          $music1.play
#          push_game_state(Chingu::GameStates::FadeTo.new(Field.new, :speed => 8)) }
      push_game_state(Field)
    }
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
    self.input = { [:left_shift, :right_shift] => :next, :p => Pause, :r => lambda{current_game_state.setup} }
  end

  def setup
    Chingu::Text.destroy_all 
    $window.caption = "StickBall!"
    @counter = 0  
    @count = 1    
    @nxt = false
    @song_fade = false
    @fade_count = 0
    @bounce = 0
    @bounce_delay = 6
    @ground_y = ($window.height * 0.95).to_i


    @title = Title.create
#    @title.y = 60
#    @title.zorder = Zorder::GUI
#    @title.x = 800/2 - @title.width/2 # center text

#    @t2 = Chingu::Text.create("StickBall", :y => 100, :font => "GeosansBold", :size => 65, :color => Colors::White, :zorder => Zorder::GUI)
#    @t2.x = 800/2 - @t2.width/2 # center text

    after(300) {
    @t1 = Chingu::Text.create("Right Player", :y => 260, :font => "GeosansBold", :size => 65, :color => Colors::White, :zorder => Zorder::GUI)
    @t1.x = 600 - @t1.width/2 # center text
    @t2 = Chingu::Text.create("Left Player", :y => 260, :font => "GeosansBold", :size => 65, :color => Colors::White, :zorder => Zorder::GUI)
    @t2.x = 200 - @t2.width/2 # center text



#      @text1 = Chingu::Text.create("StickBall", :y => 60, :font => "GeosansBold", :size => 65, :color => Colors::White, :zorder => Zorder::GUI)
#      @text1.x = 800/2 - @text1.width/2 # center text
    }
    after(600) {
      @t3 = Chingu::Text.create("Arrows", :y => 360, :font => "GeosansBold", :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
      @t3.x = 600 - @t3.width/2 # center text
#      @t4 = Chingu::Text.create("A S D W", :y => 360, :font => "GeosansBold", :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
#      @t4.x = 200 - @t4.width/2 # center text

    }
    after(900) {
      @mode_select = ModeSelect.create
      @mode_select.input = { [:right, :left, :up, :down, :a, :d, :w, :s] => :mode_select }
    }
    after(1200) {
      @text4 = Chingu::Text.create("Left Shift", :y => 500, :font => "GeosansLight", :size => 45, :zorder => Zorder::GUI)
      @text4.x = 200 - @text4.width/2 # center text
      @text5 = Chingu::Text.create("Right Shift", :y => 500, :font => "GeosansLight", :size => 45, :zorder => Zorder::GUI)
      @text5.x = 600 - @text5.width/2 # center text
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
      @nxt = false
      $click.play(0.7)
      push_game_state(Intro)
    else
      @nxt = true    # transition to Intro
      $chime.play(0.7)
      after(300) { puts 1 }
      after(600) { puts 2 }
      after(1000) { push_game_state(Intro) }
    end
  end


  def update
    @counter += @count
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




#
#  INTRODUCTION2 GAMESTATE
#
class Introduction2 < Chingu::GameState
  trait :timer
  def initialize
    super
    self.input = { [:enter, :return] => :next, :p => Pause, :r => lambda{current_game_state.setup} }
  end

  def setup
    Chingu::Text.destroy_all # destroy any previously existing Text, Player, EndPlayer, and Meteors
#    Player.destroy_all
#    EndPlayer.destroy_all
    Meteor.destroy_all
    $window.caption = "StickBall"
    @counter = 0  # used for automated Meteor creation
    @count = 1    # used for automated Meteor creation
    @nxt = false  # used for :next method ('enter')
    @song_fade = false
    @fade_count = 0
    @knight = Knight.create(:x=>900,:y=>300,:zorder=>100) # creates Knight offscreen; Knight is defined in characters.rb

    if $intro == false
      $music = Song["media/audio/music/guitar_solo.ogg"]
      $music.volume = 0.8
      $music.play(true)
    else
      $intro = false
    end

    after(300) {
      @text = Chingu::Text.create("StickBall!!!", :y => 60, :font => "GeosansLight", :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
      @text.x = 800/2 - @text.width/2 # center text
      after(300) {
        @text2 = Chingu::Text.create("Press ENTER to play", :y => 510, :font => "GeosansLight", :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
        @text2.x =800/2 - @text2.width/2 # center text
        after(300) {
#          @player = EndPlayer.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)
        }
      }
    }
  end
  
  def next
    if @nxt == true  # if you've already pressed 'enter' once, pressing it again skips ahead
      @nxt = false
      push_game_state(Field)
    else
      @nxt = true    # transition to Level 1 - Knight enters and speaks; push Level_1 gamestate
      $click.play
      after(200) {
        if @text2 != nil; @text2.destroy; end  # only destroy @text2 if it exists
        after(200) {
          if @text != nil; @text.destroy; end
          after(200) {
            @count = 0
            @knight.movement # Knight methods are defined in characters.rb
            after (1400) {
              @knight.speak
                after(10) {
                @text3 = Chingu::Text.create("Hello", :y => 220, :font => "GeosansLight", :size => 35, :color => Colors::White, :zorder => 300)
                @text3.x = 400 - @text3.width/2   # center text
                after (880) {
                  @text4 = Chingu::Text.create("Use the arrows to move", :y => 350, :font => "GeosansLight", :size => 35, :color => Colors::White, :zorder => 300)
                  @text4.x = 400 - @text4.width/2
                  after (1390) {
                    @text5 = Chingu::Text.create("and the spacebar to shoot.", :y => 390, :font => "GeosansLight", :size => 35, :color => Colors::White, :zorder => 300)
                    @text5.x = 400 - @text5.width/2
                    after(1400) {
                      @knight.enter_ship
                      after(10) {
                        @song_fade = true
                        after(800) {@text3.destroy}
                        after(1300) {@text4.destroy}
                        after(1600) {@text5.destroy}
                        after(2300) {
                          $music.stop
                          push_game_state(Field)
      } } } } } } } } } }
    end
  end

def update
    super
    @counter += @count # used for Meteor creation
    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 20
        @fade_count = 0
        $music.volume -= 0.1
      end
    end

    if(@counter >= 80)  # automated Meteor creation when @counter is __
      @random = rand(4)+1
      case @random
      when 1
        Meteor.create(x: rand(800)+1, y: 0,
                velocity_y: rand(5)+1, velocity_x: rand(-5..5),
                :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
      when 2
        Meteor.create(x: rand(800)+1, y: 600,
                velocity_y: rand(1..5)*-1, velocity_x: rand(-5..5),
                  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
      when 3
        Meteor.create(x: 0, y: rand(600)+1,
                velocity_x: rand(1..5), velocity_y: rand(-5..5),
                  :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
      when 4
        Meteor.create(x: 800, y: rand(600)+1,
                velocity_x: rand(1..5)*-1, velocity_y: rand(-5..5),
                :scale => rand(0.5)+0.4, :zorder => Zorder::Object)
      end
      @counter = 60  # resets @counter to 60
    end
    Meteor.destroy_if {|meteor| meteor.outside_window?} # self-explanatory
  end
#  def draw
#    Image["objects/background.png"].draw(0, 0, 0)    # Background Image: Raw Gosu Image.draw(x,y,zorder)-call
#    super
#  end
end

