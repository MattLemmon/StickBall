
require_relative 'lense_flares'

#
# FIELD GAMESTATE
#
class Field < Chingu::GameState    
  trait :timer
  attr_reader :puck

  def initialize
    super
    LenseFlares.load_images $window, './media/lense_flares'
    @lense_flares = LenseFlares.new $window.width/2.0, $window.height/2.0
    @star_flares = {}
    @mist = Ashton::Shader.new fragment: './rb/mist.frag', uniforms: { time: 0.0, alpha: 0.5, mist_color: [230/255.0, 250/255.0, 255/255.0, 1.0] }

    @rare_drops = ["heart", "stun", "mist"]
    @r = 0
    @drop_vel_x = 0
    @drop_vel_y = 0
    @transition = true

    self.input = { :p => Pause,
                   :r => lambda{current_game_state.setup},
                   :space => :fire,
                   :j => :toggle_left,
                   :l => :toggle_right,
                   :i => :toggle_up,
                   :k => :toggle_down,
                   :right_shift=>:right_attack,
                   :left_shift=>:left_attack,
                   [:enter, :return] => Field
                 }

    $window.caption = "Stick Ball! Go team go!"
  end

  def setup
    super
    $health1 = $start_health1
    $health2 = $start_health2
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
#    $score1 = 0
#    $score2 = 0
    $winner = ""

    @bump = 0
    @bump_delay = 15
    @bounce = 0
    @bounce_delay = 6
    @spell1_hit = false
    @spell2_hit = false
    @shake1 = 10
    @shake2 = 5
    @song_fade = false
    @fade_count = 0
    @chant = "Prepare for MultiBall"
    @multiball = false

    @ground_y = ($window.height * 0.95).to_i

    game_objects.destroy_all
    Referee.destroy_all
    Player1.destroy_all
    Player2.destroy_all
    EyesLeft.destroy_all
    EyesRight.destroy_all

    if @health1_text != nil; @health1_text.destroy; end # if it exists, destroy it
    if @health2_text != nil; @health2_text.destroy; end # if it exists, destroy it

    FireCube.destroy_all
    Star.destroy_all
#    LenseFlares.destroy_all

    Explosion.destroy_all
    Bullet.destroy_all   # destroy lingering GameObjects
#    if @player != nil; @player.destroy; end # if @player exists, destroy it

    @referee = Referee.create(:x => 400, :y => 300, :zorder => Zorder::Main_Character)
#    @referee.input = {:holding_left => :go_left, :holding_right => :go_right, :holding_up => :go_up, :holding_down => :go_down}

    @player1 = Player1.create(:x => $pos1_x, :y => $pos1_y, :zorder => Zorder::Main_Character)#(:x => $player_x, :y => $player_y, :angle => $player_angle, :zorder => Zorder::Main_Character)
    @player1.input = {:holding_right_ctrl=>:creep,:holding_left=>:go_left,:holding_right=>:go_right,:holding_up=>:go_up,:holding_down=>:go_down}

    @player2 = Player2.create(:x => $pos2_x, :y => $pos2_y, :zorder => Zorder::Main_Character)#(:x => $player_x, :y => $player_y, :angle => $player_angle, :zorder => Zorder::Main_Character)
    if $mode == "Versus"
      @player2.input = {:holding_left_ctrl=>:creep,:holding_a=>:go_left,:holding_d=>:go_right,:holding_w=>:go_up,:holding_s=>:go_down}
    end

    @health1_text = Chingu::Text.create(:text=>"#{$health1}", :y=>16, :size=>32)
    @health1_text.x = 765 - @health1_text.width/2

    @health2_text = Chingu::Text.create(:text=>"#{$health2}", :y=>16, :size=>32)
    @health2_text.x = 36 - @health2_text.width/2

    @gui1 = GUI1.create
    @gui2 = GUI2.create

    @round_text = Chingu::Text.create(:text=>"Round #{$round}", :y=>8, :size=>34)
    @round_text.x = 400 - @round_text.width/2

    @puck = FireCube.create(:x => rand(550), :y => rand(600), :zorder => Zorder::Projectile)
    @puck_flare = @lense_flares.create @puck.x, @puck.y, Zorder::LenseFlare
    @puck_flare.brightness = 0.25
    @puck_flare.strength = 0.3
    @puck_flare.scale = 1.0

#    1.times { fire }

    if $round == 1
      $music = Song["media/audio/guitar_song.ogg"]
      $music.volume = 0.4
      $music.play(true)
    elsif $round == 2
      $music = Song["media/audio/electricity_by_alexander_blu.ogg"]
      $music.volume = 0.4
      $music.play(true)
    else
      $music = Song["media/audio/guitar_solo.ogg"]
      $music.volume = 0.4
      $music.play(true)
    end

    $music.volume = 0.4
    $music.play 

    round_setup
#    Background1.create
#    @test_plax = Plax1.create

    after(2400)  { @transition = false }
#    after(22500) { puts 22500 }
    if $round == 1
      after(22400) { $music.volume = 0.2 }
    end
#    after(27500) { puts 27500 }
#    after(30000) { puts 30000 }
  end

  def round_setup
    if $round == 1
      @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
      @parallax.add_layer(:image => "backgrounds/space1.png", :damping => 40)
      @parallax.add_layer(:image => "backgrounds/space2.png", :damping => 30)
      @parallax.add_layer(:image => "backgrounds/space3.png", :damping => 20)
    end
    if $round == 2
      @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
      @parallax.add_layer(:image => "backgrounds/clouds.png", :damping => 20)
      @parallax.add_layer(:image => "backgrounds/space2.png", :damping => 15)
      @parallax.add_layer(:image => "backgrounds/space3.png", :damping => 10)
    end
    if $round == 3
      @parallax = Chingu::Parallax.create(:x => 0, :y => 0, :rotation_center => :top_left, :zorder => Zorder::Background)
      @parallax.add_layer(:image => "backgrounds/fishdish_mockup.png", :damping => 40)
      @parallax.add_layer(:image => "backgrounds/space2.png", :damping => 30)
      @parallax.add_layer(:image => "backgrounds/space3.png", :damping => 20)
    end
  end

  def right_attack
    @player1.cast_spell
#    if $spell1 == "stun"; @player2.stun; end
#    if $spell1 == "mist"; @player2.mist; end
  end
  
  def left_attack
    @player2.cast_spell
#    if $spell2 == "stun"; @player1.stun; end
#    if $spell2 == "mist"; @player1.mist; end
  end

  def fire;  chant;  end

  def chant
    if @multiball == false
      @multiball = true
      @chant_text = Chingu::Text.create("#{@chant}", :y => 520, :size => 50, :color => Colors::White, :zorder => Zorder::GUI)
      @chant_text.x = 400 - @chant_text.width/2
      after(400) { @chant_text.text = "" }
      after(800) { @chant_text.text = "#{@chant}" }
      after(1200) { @chant_text.text = "" }
      after(1600) { @chant_text.text = "#{@chant}" }
      after(2000) { @chant_text.text = ""; start_multiball }
    end
  end

  def start_multiball
    @puck2 = FireCube.create(:x => rand($window.width), :y => rand($window.height), :zorder => Zorder::Projectile)
    @puck3 = FireCube.create(:x => rand($window.width), :y => rand($window.height), :zorder => Zorder::Projectile)
    after(15000) { @puck2.destroy; @puck3.destroy; @multiball = false }
  end

#  def fire;  FireCube.create(:x => rand($window.width), :y => rand($window.height), :zorder => Zorder::Projectile);  end
  def toggle_left;  end
  def toggle_right;  end
  def toggle_up;  end
  def toggle_down;  end

  def screen_shake1
    blink_flare
    game_objects.each do |object|
      object.x += @shake1
      after(30) {object.y += @shake2}
      after(60) {object.x -= @shake1}
      after(90) {object.y -= @shake2}
      after(120) {object.x += @shake1}
      after(150) {object.y += @shake2}
      after(180) {object.x -= @shake1}
      after(210) {object.y -= @shake2}
    end
  end

  def screen_shake2
    blink_flare
    game_objects.each do |object|  # move each object left first
      object.x -= @shake1
      after(30) {object.y += @shake2}
      after(60) {object.x += @shake1}
      after(90) {object.y -= @shake2}
      after(120) {object.x -= @shake1}
      after(150) {object.y += @shake2}
      after(180) {object.x += @shake1}
      after(210) {object.y -= @shake2}
    end
  end

  def move_referee
    if @referee.y > @puck.y && rand(7) == 1
      @referee.go_up
      @referee.update_face
    end
    if @referee.y < @puck.y && rand(7) == 1
      @referee.go_down
      @referee.update_face
    end
    if @referee.x > @puck.x && rand(7) == 1
      @referee.go_left
      @referee.update_face
    end
    if @referee.x < @puck.x && rand(7) == 1
      @referee.go_right
      @referee.update_face
    end
  end

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

  def blink_flare
    after(30)  { @puck_flare.brightness += 0.6; @puck_flare.strength += 0.3;  }
    after(90)  { @puck_flare.brightness -= 0.3; @puck_flare.strength -= 0.15;  }
    after(100) { @puck_flare.brightness -= 0.3; @puck_flare.strength -= 0.15;  }
  end

  def add_star options
    star = Star.create options
    flare = @lense_flares.create star.x, star.y, Zorder::LenseFlare
    flare.color = star.color
    flare.strength = 0.25
    flare.brightness = 0.3
    flare.scale = 1.25
    flare.flickering = 0.1
    @star_flares[star] = flare
  end
  
  def remove_star star
    flare = @star_flares.delete star
    @lense_flares.delete flare
    star.destroy
  end

  def create_heart
    Heart.create(:x => @referee.x, :y => @referee.y, :velocity_x => @drop_vel_x, :velocity_y => @drop_vel_y )
  end
  def create_stun
    Stun.create(:x => @referee.x, :y => @referee.y, :velocity_x => @drop_vel_x, :velocity_y => @drop_vel_y )
  end
  def create_mist
    Mist.create(:x => @referee.x, :y => @referee.y, :velocity_x => @drop_vel_x, :velocity_y => @drop_vel_y )
  end

  def rare_drop
    @r = rand(3)
    $rare_drop = @rare_drops[@r]
#    puts $rare_drop
    if $rare_drop == "heart"
      create_heart
#      create_stun
#      @drop_vel_y *= -1
      create_mist
    end
    if $rare_drop == "stun"
      create_stun
      @drop_vel_y *= -1
      create_mist
    end
    if $rare_drop == "mist"
      create_mist
    end
  end


  def next_round
    push_game_state(Field)
  end


  def collision_check
    @star_flares.each do |star,flare|        # UPDATE STAR FLARES
      flare.x = star.x
      flare.y = star.y
    end

    Spell1.each do |spell|                   # SPELL 1 MOVEMENT
      if spell.y < @player2.y
        spell.velocity_y = 20.0
      end
      if spell.y > @player2.y
        spell.velocity_y = -20.0
      end
      if spell.y == @player2.y
        spell.velocity_y = 0
      end
      if spell.x < @player2.x
        spell.velocity_x = 30.0
      end
      if spell.x > @player2.x
        spell.velocity_x = -30.0
      end
      if spell.x == @player2.x
        spell.velocity_x = 0
      end
    end
    Spell2.each do |spell|                   # SPELL 2 MOVEMENT
      if spell.y < @player1.y
        spell.velocity_y = 20.0
      end
      if spell.y > @player1.y
        spell.velocity_y = -20.0
      end
      if spell.y == @player1.y
        spell.velocity_y = 0
      end
      if spell.x < @player1.x
        spell.velocity_x = 30.0
      end
      if spell.x > @player1.x
        spell.velocity_x = -30.0
      end
      if spell.x == @player1.x
        spell.velocity_x = 0
      end
    end

    Player1.each_collision(Spell2) do |player, spell|    # HIT PLAYER 1 WITH SPELL2
      if @spell2_hit == false
        @spell2_hit = true
        if spell.spell_type == "stun"
          player.stun
        end
        if spell.spell_type == "mist"
          player.mist
        end
        spell.destroy
        after(300) { @spell2_hit = false }
      else
        after(50) { spell.destroy }
      end
      break   #   Explosion.create(:x => spell.x, :y => spell.y)
    end
    Player2.each_collision(Spell1) do |player, spell|    # HIT PLAYER 2 WITH SPELL1
     if @spell1_hit == false
        @spell1_hit = true
        if spell.spell_type == "stun"
          player.stun
        end
        if spell.spell_type == "mist"
          player.mist
        end
        spell.destroy
        after(300) { @spell1_hit = false }
      else
        after(50) { spell.destroy }
      end
      break   #   Explosion.create(:x => spell.x, :y => spell.y)
    end

    Player1.each_collision(Star) do |player, star|    # PICKUP STARS
      remove_star star
      $stars1 += 1             # add star in star meter (gui.rb)
      if $stars1 != 5            # not 3 stars yet?
        $star_grab_right.play(0.9)     # play normal power-up sound
      else                     # 3 stars?
        $power_up_right.play(0.7)      # play mighty power-up sound
        $stars1 = 0              # reset star meter
        $power_ups1 += 1
        player1_power_up       # Power Up!
        @gui1.power_up
      end
    end
    Player2.each_collision(Star) do |player, star|    # PICKUP STARS
      remove_star star
      $stars2 += 1             # add star in star meter (gui.rb)
      if $stars2 != 5            # not 3 stars yet?
        $star_grab_left.play(0.9)     # play normal power-up sound
      else                     # 3 stars?
        $power_up_left.play(0.7)      # play mighty power-up sound
        $stars2 = 0              # reset star meter
        $power_ups2 += 1
        player2_power_up       # Power Up!
        @gui2.power_up
      end
    end

   Player1.each_collision(Heart) do |player, heart|    # PICKUP HEARTS
      heart.destroy
      $health1 += 1
      @health1_text.text = "#{$health1}"
      @health1_text.x = 765 - @health1_text.width/2
      $one_up_right.play(0.7)
    end
    Player2.each_collision(Heart) do |player, heart|    # PICKUP HEARTS
      heart.destroy
      $health2 += 1
      @health2_text.text = "#{$health2}"
      @health2_text.x = 36 - @health2_text.width/2
      $one_up_left.play(0.7)
    end

   Player1.each_collision(Stun) do |player, stun|    # PICKUP STUNS
      stun.destroy
      $spell1 = "stun"
      $stun_grab_right.play(0.9)
    end
    Player2.each_collision(Stun) do |player, stun|    # PICKUP STUNS
      stun.destroy
      $spell2 = "stun"
      $stun_grab_left.play(0.9)
    end

   Player1.each_collision(Mist) do |player, mist|    # PICKUP MISTS
      mist.destroy
      $spell1 = "mist"
      $mist_grab_right.play(0.7)
    end
    Player2.each_collision(Mist) do |player, mist|    # PICKUP MISTS
      mist.destroy
      $spell2 = "mist"
      $mist_grab_left.play(0.7)
    end

    FireCube.each_collision(Player1) do |puck, player|           # PUCK / PLAYER 1
      if @bump == 0
        player.wobble
        puck.die!
        @bump = @bump_delay
        if $kick1 == false || player.velocity_x == 0 # && player.velocity_y == 0
          if puck.velocity_x < 0
            puck.velocity_x = 10
          else
            puck.velocity_x = -10
          end
          if player.y - puck.y < -48
            puck.velocity_y = 11
          elsif player.y - puck.y < -40
            puck.velocity_y = 5
          elsif player.y - puck.y < -25
            puck.velocity_y = 3
          elsif player.y - puck.y < 25
            if puck.velocity_y >= 2.0 || puck.velocity_y <= 2.0
              puck.velocity_y = -puck.velocity_y*0.2
              if $chest_bump1 == true                # Chest Bump Ability
                if puck.velocity_x < 0
                  puck.velocity_x *= -0.05
                end
              end
            end
          elsif player.y - puck.y < 40
            puck.velocity_y = -3
          elsif player.y - puck.y < 48
            puck.velocity_y = -5
          else
            puck.velocity_y = -11
          end
        else                                         #  Kick Ability
          puck.velocity_x = player.velocity_x * 10
          puck.velocity_y = player.velocity_y * 10
          if puck.velocity_x > 0
            puck.velocity_x *= -1
          end
        end
      end
    end
    FireCube.each_collision(Player2) do |puck, player|           # PUCK / PLAYER 2
      if @bump == 0
        player.wobble
        puck.die!
        if puck.velocity_x > 0
          puck.velocity_x = -10
        else
          puck.velocity_x = 10
        end
        if player.y - puck.y < -48
          puck.velocity_y = 11
        elsif player.y - puck.y < -40
          puck.velocity_y = 5
        elsif player.y - puck.y < -25
          puck.velocity_y = 3
        elsif player.y - puck.y < 25
          if puck.velocity_y >= 2.0 || puck.velocity_y <= 2.0
            puck.velocity_y = -puck.velocity_y*0.2
            if $chest_bump2 == true
              if puck.velocity_x > 0
                puck.velocity_x *= -0.05
              end
            end
          end
        elsif player.y - puck.y < 40
          puck.velocity_y = -3
        elsif player.y - puck.y < 48
          puck.velocity_y = -5
        else
          puck.velocity_y = -11
        end
        @bump = @bump_delay
      end
    end

    FireCube.each_collision(Referee) do |puck, referee|      # ITEM DROPS  ITEM DROPS  REFEREE
      if @bump == 0
        referee.wobble
        puck.die!
        @bump = @bump_delay
        add_star :x => referee.x, :y => referee.y, :velocity_x => -puck.velocity_x/3*2, :velocity_y => puck.velocity_y/3*2
        add_star :x => referee.x, :y => referee.y, :velocity_x => -puck.velocity_x/3*2, :velocity_y => -puck.velocity_y/3*2
        if 1 == 1
          @drop_vel_x = -puck.velocity_x/3*2
          @drop_vel_y = puck.velocity_y/3*2
          rare_drop
        end
        if puck.velocity_x > 0
          puck.velocity_x = -10
        else
          puck.velocity_x = 10
        end
        if rand(2) == 1
          puck.velocity_y = 3.5
        else
          puck.velocity_y = -3.5
        end
      end
    end

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
  end

  def draw
=begin
    if @player1.mist == true && rand(20) == 1
      puts "player 1 misted"
    end
    if @player2.mist == true && rand(20) == 1
      puts "player 2 misted"
    end
=end
    @lense_flares.draw
    if @transition == false
    fill_gradient(:from => Color.new(255,0,0,0), :to => Color.new(255,60,60,80), :rect => [0,0,$window.width,@ground_y])
    fill_gradient(:from => Color.new(255,100,100,100), :to => Color.new(255,50,50,50), :rect => [0,@ground_y,$window.width,$window.height-@ground_y])
    end
    super
  end


  def update
    @parallax.camera_x = @puck.x
    @parallax.camera_y = @puck.y

    @puck_flare.x = @puck.x
    @puck_flare.y = @puck.y
    @puck_flare.color = @puck.color
    @lense_flares.update
    @mist.time = Gosu.milliseconds/1000.0
    super

    move_referee
    collision_check
    $pos1_x, $pos1_y = @player1.x, @player1.y
    $pos2_x, $pos2_y = @player2.x, @player2.y


    if @bump > 0
      @bump -= 1
    end
    if @bounce > 0
      @bounce -= 1
    end


    if $mode == "Campaign"
      if @player2.y > @puck.y && rand(5) == 1
        @player2.go_up
      end
      if @player2.y < @puck.y && rand(5) == 1
        @player2.go_down
      end
    end

    self.game_objects.destroy_if { |object| object.color.alpha == 0 }


    $window.caption = "Stick Ball!     Go team go!                                             Objects: #{game_objects.size}, FPS: #{$window.fps}"

    if @song_fade == true # fade song if @song_fade is true
      @fade_count += 1
      if @fade_count == 30
        @fade_count = 0
        $music.volume -= 0.1
      end
    end
  end
end


#    @score1_text.text = "#{$score1}"
#    @score2_text.text = "#{$score2}"
#    @health1_text.text = "#{$health1}"
#    @health2_text.text = "#{$health2}"

#    @eyes1.x = @player1.x - 3
#    @eyes1.y = @player1.y - 12
#    @eyes2.x = @player2.x + 3
#    @eyes2.y = @player2.y - 12


    #
    # GameObject.each_collsion / each_bounding_box_collision wont collide an object with itself
    #
    # FireCube.each_bounding_circle_collision(FireCube) do |cube1, cube2|  # 30 FPS on my computer
    #
    # Let's see if we can optimize each_collision, starts with 19 FPS with radius collision
    # 30 FPS by checking for radius and automatically delegate to each_bounding_circle_collision
    #
    # For bounding_box collision we start out with 7 FPS
    # Got 8 FPS, the bulk CPU consumtion is in the rect vs rect check, not in the loops.
    #