
#
#  BEGINNING GAMESTATE
#    this gamestate essentially just plays the opening music and pushes the OpeningCredits gamestate
class Beginning < Chingu::GameState
  trait :timer
  def setup
    self.input = { :esc => :exit,  [:right_shift, :left_shift] => OpeningCredits } #, :p => Pause, :r => lambda{current_game_state.setup} }
    $music = Song["audio/guitar_solo.ogg"]
    $music.volume = 0.9
    after(5) { $music.play(true) }
    after(5) { push_game_state(Chingu::GameStates::FadeTo.new(Intro.new, :speed => 20)) }
  end
end


#
#  INTRO GAMESTATE
#
class Intro < Chingu::GameState
  trait :timer
  def setup
    self.input = { [:enter, :return] => Field, :p => Pause,
                    :r => lambda{current_game_state.setup},
                    :right_shift => :ready1,
                    :left_shift => :ready2 }
    Chingu::Text.destroy_all 
    CharWheel1.destroy_all
    CharWheel2.destroy_all
    $window.caption = "StickBall"
    @counter = 0  
    @count = 1    
    @transition = false
    @song_fade = false
    @fade_count = 0
    @chant = "Prepare for Battle"
    


    after(600) {
      @player1_select = CharWheel1.create(:x => 600, :y => 300, :zorder => Zorder::Main_Character)
      @player1_select.input = { :right_shift => :ready, :right => :go_right, :left => :go_left,
                              :holding_up => :go_up, :holding_down => :go_down}
      @ready1 = false
      @caption1 = Chingu::Text.create("#{$image1}", :y => @player1_select.y - 150, :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
      @caption1.x = @player1_select.x - @caption1.width/2 # center text
    }
    after(900) {
      @player2_select = CharWheel2.create(:x => 200, :y => 300, :zorder => Zorder::Main_Character)
      @player2_select.input = {:left_shift => :ready, :a => :go_left, :d => :go_right, :holding_w => :go_up, :holding_s => :go_down}
      @ready2 = false

      @caption2 = Chingu::Text.create("#{$image2}", :y => @player2_select.y - 150, :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
      @caption2.x = @player2_select.x - @caption2.width/2 # center text
    }
    after(1500) {
      @text1 = Chingu::Text.create("Right Shift", :y => 420, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text1.x = 614 - @text1.width/2 # center text
      @text1_5 = Chingu::Text.create("to Select", :y => 452, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text1_5.x = 614 - @text1_5.width/2 # center text

      @text2 = Chingu::Text.create("Left Shift", :y => 420, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text2.x = 207 - @text2.width/2 # center text
      @text2_5 = Chingu::Text.create("to Select", :y => 452, :size => 32, :color => Colors::White, :zorder => Zorder::GUI)
      @text2_5.x = 207 - @text2_5.width/2 # center text
    }

#    after(2000) { if @text != nil; @text.destroy; end }
  end

  def ready1
    @ready1 = true
    puts "ready"
    $chime.play
    after(800) { if @text1_5 != nil; @text1_5.destroy; end }
    after(1600) { if @text1 != nil; @text1.destroy; end }
  end

  def ready2
    @ready2 = true
    puts "ready"
    $chime.play
    after(800) { if @text2_5 != nil; @text2_5.destroy; end }
    after(1600) { if @text2 != nil; @text2.destroy; end }
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
    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 10
        @fade_count = 0
        $music1.volume -= 0.1
      end
    end

    if @ready1 == true && @ready2 == true
      if @transition == false
        transition1
      end
    end
  end

  def transition1
    puts "need to add score limit selection here"
    transition2
  end

  def transition2
    @transition = true
     after(400) {
      @song_fade = true
      $guitar_riff.play(0.6) }
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
    self.input = { [:left_shift, :right_shift] => :next, :p => Pause, :r => lambda{current_game_state.setup} }
  end

  def setup
    Chingu::Text.destroy_all 
    $window.caption = "StickBall!"
    @counter = 0  
    @count = 1    
    @nxt = false  # used for :next method ('enter')
    @song_fade = false
    @fade_count = 0

    after(200) {
      @text1 = Chingu::Text.create("StickBall", :y => 60, :font => "GeosansLight", :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
      @text1.x = 800/2 - @text1.width/2 # center text
    }
    after(400) {
      @text2 = Chingu::Text.create("Opponent CPU or PL2", :y => 300, :font => "GeosansLight", :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
      @text2.x =800/2 - @text2.width/2 # center text
    }
    after(600) {
      @text3 = Chingu::Text.create("Select score limit", :y => 400, :font => "GeosansLight", :size => 45, :color => Colors::White, :zorder => Zorder::GUI)
      @text3.x =800/2 - @text3.width/2 # center text
    }
    after(800) {
      @text4 = Chingu::Text.create("Left Shift to begin", :y => 500, :font => "GeosansLight", :size => 45, :zorder => Zorder::GUI)
      @text4.x = 200 - @text4.width/2 # center text
      @text5 = Chingu::Text.create("Right Shift to begin", :y => 500, :font => "GeosansLight", :size => 45, :zorder => Zorder::GUI)
      @text5.x = 600 - @text5.width/2 # center text

    }
  end

  def next
    if @nxt == true  # if you've already pressed 'shift' once, pressing it again skips ahead
      @nxt = false
      $click.play
      push_game_state(Intro)
    else
      @nxt = true    # transition to Field
      $click.play
      after(300) { puts 1 }
      after(600) { puts 2 }
      after(1000) { push_game_state(Intro) }
    end
  end


def update
    super
    @counter += @count 
    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 20
        @fade_count = 0
        $music.volume -= 0.1
      end
    end
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
    $window.caption = "StickBall!"
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

