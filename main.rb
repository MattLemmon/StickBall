
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
require_relative 'rb/round_change'
require_relative 'rb/crowd'


module Zorder  # define some frequently used Zorders
  GUI = 400
  GUI_Bkgrd = 399
  Text = 300
  Main_Character = 150
  Face = 151
  Eyes = 151
  Main_Character_Particles = 149
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
    @title = Chingu::Text.create(:text=>"PAUSED (press 'P' to un-pause)", :y=>300, :size=>30, :color => Color.new(0xFF00FF00), :zorder=>1000 )
    @title.x = 400 - @title.width/2
    @t2 = Chingu::Text.create(:text=>"press 'M' to return to Main Menu", :y=>350, :size=>30, :color => Color.new(0xFF00FF00), :zorder=>1000 )
    @t2.x = 400 - @t2.width/2
    @t3 = Chingu::Text.create(:text=>"press 'esc' to exit", :y=>400, :size=>30, :color => Color.new(0xFF00FF00), :zorder=>1000 )
    @t3.x = 400 - @t3.width/2

    self.input = { :p => :un_pause, :m => PreIntro }
  end
  def un_pause
    pop_game_state(:setup => false)    # Return the previous game state, dont call setup()
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
    $pos1_x, $pos1_y = 740, 300
    $pos2_x, $pos2_y = 60, 300
    $max_x = 815
    $max_y = 615
    $scr_edge = 15
    $image1 = "boy"
    $image2 = "boy"
    $chime = Sound["media/audio/pickup_chime.ogg"]
    $chime_right = Sound["media/audio/chime_right.ogg"]
    $chime_left = Sound["media/audio/chime_left.ogg"]
    $click = Sound["media/audio/keypress.ogg"]
    $click_right = Sound["media/audio/click_right.ogg"]
    $click_left = Sound["media/audio/click_left.ogg"]
    #$star_grab = Sound["media/audio/star_pickup.ogg"]
    $star_grab_right = Sound["media/audio/star_grab_right.ogg"]
    $star_grab_left = Sound["media/audio/star_grab_left.ogg"]
    $power_up_left = Sound["media/audio/power_up_left.ogg"]
    $power_up_right = Sound["media/audio/power_up_right.ogg"]
    $mist_grab_left = Sound["media/audio/mist_grab_left.ogg"]
    $mist_grab_right = Sound["media/audio/mist_grab_right.ogg"]
    $stun_grab_right = Sound["media/audio/stun_grab_right.ogg"]
    $stun_grab_left = Sound["media/audio/stun_grab_left.ogg"]
    $one_up_left = Sound["media/audio/1up_left.ogg"]
    $one_up_right = Sound["media/audio/1up_right.ogg"]
    $zapped = Sound["media/audio/magical_zap_by_qubodup.ogg"]
    $stunned = Sound["media/audio/stunned.ogg"]
    $misted = Sound["media/audio/misted.ogg"]
    #$spell_cast = Sound["media/audio/magic_fireball_by_joelaudio.ogg"]
    $spell_cast1 = Sound["media/audio/spell_cast_right.ogg"]
    $spell_cast2 = Sound["media/audio/spell_cast_left.ogg"]
    $bang = Sound["media/audio/bang.ogg"]
    $bang1 = Sound["media/audio/bang1.ogg"]
    $bang2 = Sound["media/audio/bang2.ogg"]
    $game_over = Sound["media/audio/game_over.ogg"]
    $guitar_fill = Sound["media/audio/guitar_fill.ogg"]
    #$guitar_riff = Sound["media/audio/guitar_riff_short.ogg"]
    #$hold_music1 = Sound["media/audio/hold_music1.ogg"]
    #$hold_music2 = Sound["media/audio/hold_music2.ogg"]
    #$hold_music3 = Sound["media/audio/hold_music3.ogg"]
    #$hold_music4 = Sound["media/audio/hold_music4.ogg"]
    #$guitar_solo = Song["media/audio/guitar_solo.ogg"]
    #$guitar_song = Song["media/audio/guitar_song.ogg"]
    self.caption = "Stick Ball"
    @cursor = true # comment out to hide cursor
    self.input = { :esc => :exit,
                   :z => :log
                 }
    retrofy
  end

  def setup
    push_game_state(Beginning)
#    push_game_state(CrowdScene2)
  end

  def log
    puts $window.current_game_state
  end
end

GameWindow.new.show


#  def pop
#    puts "pop"
#    if $window.current_game_state.to_s != "Beginning"
#      pop_game_state(:setup => true)
#    end
#  end

