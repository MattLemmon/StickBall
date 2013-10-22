class LenseFlares
  require_relative 'lense_flare'
  
  attr_reader :center_x, :center_y
  attr_accessor :lense_flares
  
  def initialize center_x, center_y
    @center_x = center_x
    @center_y = center_y
    destroy_all
  end
  
  def destroy_all
    @lense_flares = []
  end

  def delete flare
    @lense_flares.delete flare
  end
  
  def create x, y, z
    lense_flare = LenseFlare.new self, x, y, z
    @lense_flares << lense_flare
    lense_flare
  end
  
  def update
    @lense_flares.each &:update
  end
  
  def draw
    @lense_flares.each &:draw
  end
  
  def self.load_images window, load_path
    LenseFlare.load_images window, load_path
  end
end