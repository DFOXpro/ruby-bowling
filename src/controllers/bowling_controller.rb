# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require_relative './input_file_controller.rb'
require_relative './output_controller.rb'
require_relative '../models/player_score.rb'
require_relative '../views/bowling_view.rb'

# This class process the input data and present the bowling score card
class BowlingController

	# Process the input file data and present the bowling score card if the input
	# offers valid players.
	#
	# Can print players with no shots or incomplete shots
	def self.process
		raw_data = InputFileController.get_raw_data
		raw_data.each {|input_line| PlayerScore.digest_input_line input_line}
		if PlayerScore.player_list.keys.size > 0
			OutputFileController.print BowlingView.print_scores PlayerScore.player_list
		end
	end
end
