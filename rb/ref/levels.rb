
#
#   LEVEL 1 GAMESTATE
#      This is where the actual gameplay begins
class Level_1 < Chingu::GameState
  trait :timer
  def initialize
    super
    $health = 6   # starting health is 6      These constants are updated throughout the game.
    $score = 0    # starting score is 0
    $stars = 0    # starting stars is 0
    $weapon = 1   # starting weapon is 1
    self.input = { :return => Level_2, :p => Pause, :r => lambda{ current_game_state.setup } }
    $window.caption = "Level 1"
  end

  def setup
    super
    Bullet.destroy_all   # destroy lingering GameObjects
    Player.destroy_all
    Star.destroy_all
    Meteor.destroy_all
    Meteor1.destroy_all
    Meteor2.destroy_all
    Meteor3.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end # if @player exists, destroy it
    # Player class is defined in objects.rb
    @player = Player.create(:x => 400, :y => 450, :zorder => Zorder::Main_Character)#(:x => $player_x, :y => $player_y, :angle => $player_angle, :zorder => Zorder::Main_Character)
    @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}
    @gui = GUI.create(@player)      # create GUI
    @shaking = true                 # screen_shake cooldown
    after(1000) {@shaking = false}

    $music = Song["media/audio/music/stageoids.ogg"]  # switch music track to Stageoids theme by ExplodingCookie
    Sound["media/audio/asplode.ogg"]   # cache sound
    Sound["media/audio/exploded.ogg"]  # cache sound

    @player.cool_down      # player cannot be damaged when blinking (Player.cool_down from objects.rb)
    1.times { new_meteor } # creates meteors

    after(100) {           # plays game music by ExplodingCookie after brief pause
      $music.play(true)
      $music.volume = 0.25
    }
  end

  def new_meteor           # creates 3 meteors and 3 stars (from objects.rb)
    Meteor1.create(:x => rand * 800, :y => rand * 600)
    Meteor2.create(:x => rand * 800, :y => rand * 600)
    Meteor3.create(:x => rand * 800, :y => rand * 600)
    Star.create
    Star.create
    Star.create
  end

  def collision_check
    Player.each_collision(Star) do |player, star|    # Collide player with stars
      star.destroy            # pick up star
      $score += 300           # increase score
      $stars += 1             # add star in star meter (gui.rb)
      if $stars != 3          # not 3 stars yet?
        $star_grab.play(0.6)   # play normal power-up sound
      else                    # 3 stars?
        $power_up.play(0.6)    # play mighty power-up sound
        $stars = 0             # reset star meter
        $weapon += 1           # Upgrade Weapon (see Player.fire in objects.rb)
      end
    end
    Bullet.each_collision(Meteor1) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)    # create explosion
      Meteor2.create(:x => meteor.x, :y => meteor.y)      # create two smaller meteors
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100                                       # increase score
      Sound["media/audio/explosion.ogg"].play(0.2)
      break   # makes it so that meteors only split once when hit (thanks to Spooner)
    end
    Bullet.each_collision(Meteor2) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)    # create explosion
      Meteor3.create(:x => meteor.x, :y => meteor.y)      # create two smaller meteors
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
      break                                               # meteors split only once when hit
    end
    Bullet.each_collision(Meteor3) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
      break                                               # meteors split only once when hit
    end

    Player.each_collision(Meteor1) do |starship, meteor|    # Collide player with meteors
      @player.damage    # calls Player.damage (objects.rb); no damage when blinking
      screen_shake      # do screen_shake method (see below)
    end
    Player.each_collision(Meteor2) do |starship, meteor|    # Collide player with meteors
      @player.damage
      screen_shake
    end
    Player.each_collision(Meteor3) do |starship, meteor|    # Collide player with meteors
      @player.damage
      screen_shake
    end
  end

  def screen_shake        
    if @shaking == false   # if screen shake is cooled down
      game_objects.each do |object|  # move each object right, down, left, up, right, down, left, up
        object.x += 10
        after(30) {object.y += 10}   # 30 ms tick time delay between each movement
        after(60) {object.x -= 10}
        after(90) {object.y -= 10}
        after(120) {object.x += 10}
        after(150) {object.y += 10}
        after(180) {object.x -= 10}
        after(210) {object.y -= 10}
      end
      @shaking = true  # screen_shake won't occur again until this becomes false
      after(1000) {@shaking = false}  # after 1000 ms, screen can shake again
    end
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image
    super
  end

  def update
    super
    collision_check                              # do collision_check method (see above)
    $player_x, $player_y = @player.x, @player.y  # save player's position, angle and velocity for next level
    $player_angle, $player_x_vel, $player_y_vel = @player.angle, @player.velocity_x, @player.velocity_y
    if Meteor1.size + Meteor2.size + Meteor3.size == 0   # if there are no meteors
      after(1000) { push_game_state(Level_2) }           #   push Level_2 gamestate
    end
    if $health == 0    # if $health is zero, explode player and push GameOver gamestate
      Explosion.create(:x => @player.x, :y => @player.y)
      @player.destroy
      $music.stop
      after(1000) { push_game_state(Chingu::GameStates::FadeTo.new(GameOver.new, :speed => 10)) }
    end
  end
end



#
#   LEVEL 2 GAMESTATE
#     nearly identical to Level_1, but with more meteors
class Level_2 < Chingu::GameState
  trait :timer
  def initialize
    super
    self.input = { :return => Level_3, :p => Pause, :r => lambda{ current_game_state.setup } }
    $window.caption = "Level 2"
  end

  def setup
    super
    Bullet.destroy_all    # destroy lingering GameObjects
    Player.destroy_all
    Star.destroy_all
    Meteor1.destroy_all
    Meteor2.destroy_all
    Meteor3.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end
    # Player location, angle, and velocity were saved as constants in Level_1.update
	  @player = Player.create(:x => $player_x, :y => $player_y, :angle => $player_angle, :velocity_x => $player_x_vel, :velocity_y => $player_y_vel, :zorder => Zorder::Main_Character)
	  @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}
    @gui = GUI.create(@player)
    @shaking = true
    after(1000) {@shaking = false}

    Sound["media/audio/asplode.ogg"]  # cache sound
    Sound["media/audio/exploded.ogg"] # cache sound

    @player.cool_down
    2.times { new_meteor }   # creates 6 meteors and 4 stars

  end

  def new_meteor
    Meteor1.create(:x => rand * 800, :y => rand * 600)
    Meteor2.create(:x => rand * 800, :y => rand * 600)
    Meteor3.create(:x => rand * 800, :y => rand * 600)
    Star.create
    Star.create
  end

  def collision_check
    Player.each_collision(Star) do |player, star|    # Collide player with stars
      star.destroy
      $score += 300
      $stars += 1
      if $stars != 3
        $star_grab.play(0.6)
      else
        $power_up.play(0.6)
        $stars = 0
        $weapon += 1
      end
    end
    Bullet.each_collision(Meteor1) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/explosion.ogg"].play(0.2)
      break
    end
    Bullet.each_collision(Meteor2) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
      break
    end
    Bullet.each_collision(Meteor3) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
      break
    end
    Player.each_collision(Meteor1) do |starship, meteor|    # Collide player with meteors
      @player.damage
      screen_shake
    end
    Player.each_collision(Meteor2) do |starship, meteor|    # Collide player with meteors
      @player.damage
      screen_shake
    end
    Player.each_collision(Meteor3) do |starship, meteor|    # Collide player with meteors
      @player.damage
      screen_shake
    end
  end

  def screen_shake
    if @shaking == false
      @shaking = true
      game_objects.each do |object|
        object.x += 10
        after(30) {object.y += 10}
        after(60) {object.x -= 10}
        after(90) {object.y -= 10}
        after(120) {object.x += 10}
        after(150) {object.y += 10}
        after(180) {object.x -= 10}
        after(210) {object.y -= 10}
      end
     after(1000) {@shaking = false}
    end
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image
    super
  end

  def update
    super
    collision_check
    $player_x, $player_y = @player.x, @player.y  # save position, angle, velocity for next level
    $player_angle, $player_x_vel, $player_y_vel = @player.angle, @player.velocity_x, @player.velocity_y
    if Meteor1.size + Meteor2.size + Meteor3.size == 0
      after(1000) { push_game_state(Level_3) }
    end
    if $health == 0
      Explosion.create(:x => @player.x, :y => @player.y)
      @player.destroy
      $music.stop
      after(1000) { push_game_state(Chingu::GameStates::FadeTo.new(GameOver.new, :speed => 10)) }
    end
  end
end


#
#   LEVEL 3 GAMESTATE
#     almost the same as Level_1 and Level_2
class Level_3 < Chingu::GameState
  trait :timer
  def initialize
    super
    self.input = { :return => Win, :p => Pause, :r => lambda{ current_game_state.setup } }
    $window.caption = "Level 3"
  end

  def setup
    super
    Bullet.destroy_all
    Player.destroy_all
    Star.destroy_all
    Meteor1.destroy_all
    Meteor2.destroy_all
    Meteor3.destroy_all
    Explosion.destroy_all
    if @player != nil; @player.destroy; end

    @player = Player.create(:x => $player_x, :y => $player_y, :angle => $player_angle, :velocity_x => $player_x_vel, :velocity_y => $player_y_vel, :zorder => Zorder::Main_Character)
    @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :holding_up => :accelerate, :holding_down => :brake, :space => :fire}
    @gui = GUI.create(@player)
    @shaking = true
    after(1000) {@shaking = false}

    @song_fade = false   # music fade used at end of gamestate
    @fade_count = 0
    Sound["media/audio/asplode.ogg"]  # cache sound
    Sound["media/audio/exploded.ogg"]

    @player.cool_down
    3.times { new_meteor }

  end

  def new_meteor
    Meteor1.create(:x => rand * 800, :y => rand * 600)
    Meteor2.create(:x => rand * 800, :y => rand * 600)
    Meteor3.create(:x => rand * 800, :y => rand * 600)
    Star.create
    Star.create
  end

  def collision_check
    Player.each_collision(Star) do |player, star|    # Collide player with stars
      star.destroy
      $score += 300
      $stars += 1
      if $stars != 3
        $star_grab.play(0.6)
      else
        $power_up.play(0.6)
        $stars = 0
        $weapon += 1
      end
    end
    Bullet.each_collision(Meteor1) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      Meteor2.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/explosion.ogg"].play(0.2)
      break
    end
    Bullet.each_collision(Meteor2) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      Meteor3.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
      break
    end
    Bullet.each_collision(Meteor3) do |bullet, meteor|    # Collide bullets with meteors
      Explosion.create(:x => meteor.x, :y => meteor.y)
      meteor.destroy
      bullet.destroy
      $score += 100
      Sound["media/audio/asplode.ogg"].play(0.2)
      break
    end
    Player.each_collision(Meteor1) do |starship, meteor|    # Collide player with meteors
      @player.damage
      screen_shake
    end
    Player.each_collision(Meteor2) do |starship, meteor|    # Collide player with meteors
      @player.damage
      screen_shake
    end
    Player.each_collision(Meteor3) do |starship, meteor|    # Collide player with meteors
      @player.damage
      screen_shake
    end
  end

  def screen_shake
    if @shaking == false
      @shaking = true
      game_objects.each do |object|
        object.x += 10
        after(30) {object.y += 10}
        after(60) {object.x -= 10}
        after(90) {object.y -= 10}
        after(120) {object.x += 10}
        after(150) {object.y += 10}
        after(180) {object.x -= 10}
        after(210) {object.y -= 10}
      end
     after(1000) {@shaking = false}
    end
  end

  def draw
    Image["../media/assets/background.png"].draw(0, 0, 0)    # Background Image
    super
  end

  def update
    super
    collision_check
    $player_x, $player_y = @player.x, @player.y  # save position, angle, velocity for next level
    $player_angle, $player_x_vel, $player_y_vel = @player.angle, @player.velocity_x, @player.velocity_y
    if $health == 0
      Explosion.create(:x => @player.x, :y => @player.y)
      @player.destroy
      $music.stop
      after(1000) { push_game_state(Chingu::GameStates::FadeTo.new(GameOver.new, :speed => 10)) }
    end
    if Meteor1.size + Meteor2.size + Meteor3.size == 0   # if there are no more meteors
      after(1000) { @song_fade = true }                    # fade out music
      after(3000) { push_game_state(Win) }                 # push Win gamestate   This is the exact moment when you win!
    end

    if @song_fade == true  # music fades out when true
      @fade_count += 1
      if @fade_count == 20
        @fade_count = 0
        $music.volume -= 0.1
      end
    end

  end
end

