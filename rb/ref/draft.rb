
#                   :space => :fire,
#                   :j => :toggle_left,
#                   :l => :toggle_right,
#                   :i => :toggle_up,
#                   :k => :toggle_down,

#  def fire;  start_multiball;  end
#  def fire;  FireCube.create(:x => rand($window.width), :y => rand($window.height), :zorder => Zorder::Projectile);  end
  def toggle_left;  end
  def toggle_right;  end
  def toggle_up;  end
  def toggle_down;  end



  def player1_power_up
    if $power_ups1 == 1
      $speed1 = 10
    end
    if $power_ups1 == 2
      $creep1 = true
    end
    if $power_ups1 == 3
      $chest_bump1 = true
    end
    if $power_ups1 == 4
      $kick1 = true
    end
  end

  def player2_power_up
    if $power_ups2 == 1
      $speed2 = 10
    end
    if $power_ups2 == 2
      $creep2 = true
    end
    if $power_ups2 == 3
      $chest_bump2 = true
    end
    if $power_ups2 == 4
      $kick2 = true
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








=begin
          if $health1 > 1
            $health1 -=1
            @health1_text.text = "#{$health1}"
            @health1_text.x = 765 - @health1_text.width/2
          elsif $round < 3
            $round += 1
            $score2 += 1
            @round_text.text = "Round #{$round}"
            @round_text.x = 400 - @round_text.width/2
            puts "round #{$round}"
            puts "score1 #{$score1}"
            puts "score2 #{$score2}"
            push_game_state(FieldChange)
          else
            $score2 += 1
            $winner = "left player"
            $round = 1
            push_game_state(GameOver)
          end
=end



  # Characters Class
  def setup
    #...
    #@yy           = rand() ** 4.0
    @yy           = rand() ** 2.0
    @xx           = rand()

    @offset_x = 0
    @offset_y = 30

    # self.y = rand() ** 4.0 * 130 + 350
    #self.factor = (@y-300)/300.0  # character size is affected by y position
    #self.factor = 0.7
    self.factor = @yy * 0.7 + 0.4
    #self.zorder = self.factor.abs * 400
    self.zorder = @yy * 300
    #col = ((self.factor) * 2.0) ** 2.0 * 255
    # self.x = rand(self.factor * 800) + (1.0 - self.factor) * 500
  end

  # Field Gamestate collision_detection
    FireCube.each do |particle|             # SCORING AND WALL-BOUNCING  SCORING  SCORING
      if @bounce == 0
        if particle.x < 0
          particle.x = 0
          particle.velocity_x = -particle.velocity_x
#          $score1 += 1
          $bang2.play(0.3)
          if $health2 > 1
            $health2 -=1
            @health2_text.text = "#{$health2}"
            @health2_text.x = 38 - @health2_text.width/2
          elsif $round < 3
            $round += 1
            $score1 += 1
            @round_text.text = "Round #{$round}"
            @round_text.x = 400 - @round_text.width/2
            puts "round #{$round}"
            puts "score1 #{$score1}"
            puts "score2 #{$score2}"
#            next_round
            push_game_state(FieldChange)
          else
            $score1 += 1
            $winner = "right player"
            $round = 1
            push_game_state(GameOver)
          end
          particle.die!
          screen_shake1
          @referee.update_face
          @player1.update_face
          @player2.update_face
          @bounce = @bounce_delay
        end
        if particle.x > $window.width
          particle.x = $window.width
          particle.velocity_x = -particle.velocity_x
#          $score2 += 1
          $bang1.play(0.4)
          if $health1 > 1
            $health1 -=1
            @health1_text.text = "#{$health1}"
            @health1_text.x = 765 - @health1_text.width/2
          elsif $round < 3
            $round += 1
            $score2 += 1
            @round_text.text = "Round #{$round}"
            @round_text.x = 400 - @round_text.width/2
            puts "round #{$round}"
            puts "score1 #{$score1}"
            puts "score2 #{$score2}"
            push_game_state(FieldChange)
          else
            $score2 += 1
            $winner = "left player"
            $round = 1
            push_game_state(GameOver)
          end
          particle.die!
          screen_shake2
          @referee.update_face
          @player1.update_face
          @player2.update_face
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





#
# BACKGROUND 1
#
class Background1 < Chingu::GameObject
  
  def setup
    @parallax1 = Image["backgrounds/space1.png"]
    @parallax2 = Image["backgrounds/space2.png"]
    @parallax3 = Image["backgrounds/space3.png"]
    @parallax4 = Image["backgrounds/space1.png"]
    @parallax5 = Image["backgrounds/space2.png"]
    @parallax6 = Image["backgrounds/space3.png"]

#    @parallax1.x = 0
#    @parallax1.y = 0
#    @parallax2.x = 0
#    @parallax2.y = 0
#    @parallax3.x = 0
#    @parallax3.y = 0
#    @parallax4.x = 0
    @parallax4.y = -800
    @parallax5.y = -800
    @parallax6.y = -800



#    @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
#    @parallax.add_layer(:image => "backgrounds/space1.png", :damping => 16)
#    @parallax.add_layer(:image => "backgrounds/space2.png", :damping => 12)
#    @parallax.add_layer(:image => "backgrounds/space3.png", :damping => 8)
#    @parallax2 = Chingu::Parallax.create(:x => 0, :y => -800, :rotation_center => :top_left, :zorder => Zorder::Background)
#    @parallax2.add_layer(:image => "backgrounds/space1.png", :damping => 16)
#    @parallax2.add_layer(:image => "backgrounds/space2.png", :damping => 12)
#    @parallax2.add_layer(:image => "backgrounds/space3.png", :damping => 8)
  end


  def left
    @parallax1.x += 2
    @parallax2.x += 2
    @parallax3.x += 2
    @parallax4.x += 2

  end

  def right
#    @parallax.x += 2     # This is essentially the same as @parallax.x -= 2
#    @parallax2.x += 3
  end  
  def camera_up
#    @parallax.camera_y -= 1     # This is essentially the same as @parallax.y += 2
#    @parallax2.camera_y -= 5
  end
  def camera_down
#    @parallax.camera_y += 1    # This is essentially the same as @parallax.y -= 2
#    @parallax2.camera_y += 5
  end

  def update
    camera_right
    camera_up
  end
end








  def draw
    $window.post_process @mist do
      fill_gradient(:from => Color.new(255,0,0,0), :to => Color.new(255,60,60,80), :rect => [0,0,$window.width,@ground_y])
      fill_gradient(:from => Color.new(255,100,100,100), :to => Color.new(255,50,50,50), :rect => [0,@ground_y,$window.width,$window.height-@ground_y])    
      super
      @lense_flares.draw
    end
  end

=begin
#    @lense_flares.draw
    if @player1.mist == true or @player2.mist == true
      $window.post_process @mist do
        super
        @lense_flares.draw
      end
    elsif @transition == false
      fill_gradient(:from => Color.new(255,0,0,0), :to => Color.new(255,60,60,80), :rect => [0,0,$window.width,@ground_y])
      fill_gradient(:from => Color.new(255,100,100,100), :to => Color.new(255,50,50,50), :rect => [0,@ground_y,$window.width,$window.height-@ground_y])
      super
      @lense_flares.draw
    else
      super
    end
  end
=end

  def update
      $window.caption = "Stick Ball!     Go team go!                                             Objects: #{game_objects.size}, FPS: #{$window.fps}"

    if @transition == false
      @puck_flare.x = @puck.x
      @puck_flare.y = @puck.y
      @puck_flare.color = @puck.color
      @lense_flares.update
      @mist.time = Gosu.milliseconds/1000.0
    end
    super

    move_referee
    collision_check
    if @bump > 0
      @bump -= 1
    end
    if @bounce > 0
      @bounce -= 1
    end

    @score1_text.text = "#{$score1}"
    @score2_text.text = "#{$score2}"

#    @eyes1.x = @player1.x - 3
#    @eyes1.y = @player1.y - 12
#    @eyes2.x = @player2.x + 3
#    @eyes2.y = @player2.y - 12

    if @player3 != nil
      if @player3.y > @puck.y && rand(5) == 1
        @player3.go_up
      end
      if @player3.y < @puck.y && rand(5) == 1
        @player3.go_down
      end
    end

    self.game_objects.destroy_if { |object| object.color.alpha == 0 }
  end
end

