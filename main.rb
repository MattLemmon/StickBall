
require 'chingu'
require 'gosu'
require 'ashton'
include Chingu
include Gosu


require_relative 'rb/field'
require_relative 'rb/players'
require_relative 'rb/objects'
require_relative 'rb/gui'
require_relative 'rb/beginning'
require_relative 'rb/ending'
require_relative 'rb/backgrounds'


module Zorder  # define some frequently used Zorders
  GUI = 400
  GUI_Bkgrd = 399
  Text = 300
  Main_Character = 200
  Face = 201
  Eyes = 201
  Main_Character_Particles = 199
  Object = 50
  Projectile = 220
  LenseFlare = 221
  Particle = 210
  Background = 5
end


module Colors   # define some colors
  Dark_Orange = Gosu::Color.new(0xFFCC3300)
  White = Gosu::Color.new(0xFFFFFFFF)
  Blue_Laser = Gosu::Color.new(0xFF86EFFF)
end


#
#  PAUSE GAMESTATE
#
class Pause < Chingu::GameState
  def initialize(options = {})
    super
#    @title = Chingu::Text.create(:text=>"PAUSED (press 'P' to un-pause)", :y=>300, :size=>30, :color => Color.new(0xFF00FF00), :zorder=>1000 )
#    @title.x = 400 - @title.width/2
    self.input = { :p => :un_pause, :r => :reset }
  end
  def un_pause
    pop_game_state(:setup => false)    # Return the previous game state, dont call setup()
  end  
  def reset
    pop_game_state(:setup => true)
  end
  def draw
    previous_game_state.draw    # Draw prev game state onto screen (in this case our level)
    super                       # Draw game objects in current game state, this includes Chingu::Texts
  end  
end




#
#  GameWindow Class
#
class GameWindow < Chingu::Window
  def initialize
    super(800,600,false)
    $round = 1
    $intro = true
    $max_x = 815
    $max_y = 615
    $scr_edge = 15
    $cooling_down = 70
    $score = 0
    $mode = "Campaign"
    $image1 = "boy"
    $image2 = "boy"
    $chime = Sound["media/audio/pickup_chime.ogg"]
    $chime_right = Sound["media/audio/chime_right.ogg"]
    $chime_left = Sound["media/audio/chime_left.ogg"]
    $click = Sound["media/audio/keypress.ogg"]
    $click_right = Sound["media/audio/click_right.ogg"]
    $click_left = Sound["media/audio/click_left.ogg"]
    $star_grab = Sound["media/audio/star_pickup.ogg"]
    $power_up = Sound["media/audio/power_up.ogg"]
    $power_up = Sound["media/audio/power_up.ogg"]
#    $one_up = Sound["media/audio/1up.ogg"]
    $zapped = Sound["media/audio/magical_zap_by_qubodup.ogg"]
    $stunned = Sound["media/audio/stunned.ogg"]
    $misted = Sound["media/audio/misted.ogg"]
    $spell_cast = Sound["media/audio/magic_fireball_by_joelaudio.ogg"]
    $bang = Sound["media/audio/bang.ogg"]
    $bang1 = Sound["media/audio/bang1.ogg"]
    $bang2 = Sound["media/audio/bang2.ogg"]
    $guitar_riff = Sound["media/audio/guitar_riff_short.ogg"]
    $music1 = Song["media/audio/guitar_solo.ogg"]
    $music2 = Song["media/audio/guitar_song.ogg"]
    self.caption = "Stick Ball"
    @cursor = true # comment out to hide cursor
    self.input = { :esc => :exit,
#                   :enter => :next,
#                   :return => :next,
                 [:q, :l] => :pop,
                 :z => :log,
                 :r => lambda{current_game_state.setup}
               }
    retrofy
  end

  def setup
    push_game_state(Beginning)
  end

  def log
    puts $window.current_game_state
  end

#  def next
#    push_game_state(Beginning)
#  end

  def pop
    puts "pop"
    if $window.current_game_state.to_s != "Beginning"
      pop_game_state(:setup => true)
    end
  end
end


GameWindow.new.show # change to Game.new.show to see alternate window class