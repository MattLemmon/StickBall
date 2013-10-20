

#
#  GUI CLASS
#    Health Meter, Star Meter, Score
class GUI < Chingu::GameObject
	def initialize(player)
		super()
		@gui_player = player
		@heart_full = Gosu::Image.new($window, "gui/heart.png")
		@heart_half = Gosu::Image.new($window, "gui/heart_half.png")
		@heart_empty = Gosu::Image.new($window, "gui/heart_empty.png")
		@star_full = Gosu::Image.new($window, "gui/star_full.png")
#		@star_half = Gosu::Image.new($window, "gui/star_half.png")
		@star_empty = Gosu::Image.new($window, "gui/star_empty.png")

		@score_text = Chingu::Text.create("Score: #{$score}", :y => 0, :font => "GeosansLight", :size => 20, :color => Colors::White, :zorder => Zorder::GUI)
		@score_text.x = 800/2 - @score_text.width/2
	end

	def update
		super
		@score_text.text = "Score: #{$score}"
	end

	def draw      # draw health meter and star meter according to $health and $stars
		if $health == 6                                     # Health Meter
			for i in 0..2
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 5
			for i in 0..1
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 2..2
				@heart_half.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 4
			for i in 0..1
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 2..2
				@heart_empty.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 3
			for i in 0..0
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 1..1
				@heart_half.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 2..2
				@heart_empty.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 2
			for i in 0..0
				@heart_full.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 1..2
				@heart_empty.draw(18*i+2, 0, Zorder::GUI)
			end
		elsif $health == 1
			for i in 0..0
				@heart_half.draw(18*i+2, 0, Zorder::GUI)
			end
			for i in 1..2
				@heart_empty.draw(18*i+2, 0, Zorder::GUI)
			end		
		end

		if $stars == 0                                         # Star Meter
			for i in 0..2
				@star_empty.draw(18*i+70, 0, Zorder::GUI)
			end
		elsif $stars == 1
			for i in 0..0
				@star_full.draw(18*i+70, 0, Zorder::GUI)
			end
			for i in 1..2
				@star_empty.draw(18*i+70, 0, Zorder::GUI)
			end
		elsif $stars == 2
			for i in 0..1
				@star_full.draw(18*i+70, 0, Zorder::GUI)
			end
			for i in 2..2
				@star_empty.draw(18*i+70, 0, Zorder::GUI)
			end
		elsif $stars == 3
			for i in 0..2
				@star_full.draw(18*i+70, 0, Zorder::GUI)
			end
		end
	end
end
