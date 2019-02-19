# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co

# This class will show the bowling score card
class BowlingView # < Localization
	class << self

		# Will show the bowling score card of the given players
		# @param player_list [array<PlayerScore>, #read] the list of players to be printed in the card
		def print_scores(
			player_list
		)
			@output_text = ""
			header = "Frame"
			10.times {|i| header += "\t\t#{i+1}" }
			_print "#{header}\n"
			player_list.each do |key, player|
				_print "#{player.name}\n"
				pinfalls = "Pinfalls"
				score = "Score"
				player.frames.each_index do | frame_i|
					frame = player.frames[frame_i]
					score +="\t\t#{player.get_score(frame_i)}"
					if frame_i == 9
						frame.each do |shot|
							pinfalls += (shot == 10 ? "\tX" : "\t#{shot}")
						end
					elsif player.strike?(frame_i)
						pinfalls += "\t\tX"
					else # spare
						pinfalls += "\t#{frame[0]}"
						pinfalls += _spare player, frame, frame_i, 1
					end
				end
				_print "#{pinfalls}\n#{score}\n"
			end
			return @output_text
		end

		private

		# A mixin of how spares are printed
		def _spare(player, frame, frame_i, shot)
			r = ''
			if not frame[shot].nil?
				r = "\t#{player.spare?(frame_i) ? '/' : frame[shot]}"
			end
			return r
		end

		# a proxy method to the printing card
		def _print(text)
			@output_text += text
		end

	end
end
