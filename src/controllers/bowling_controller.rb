# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join File.dirname(__FILE__), './input_file_controller.rb'
require File.join File.dirname(__FILE__), './output_controller.rb'
require File.join File.dirname(__FILE__), '../models/player_score.rb'
require File.join File.dirname(__FILE__), '../views/bowling_view.rb'

# This class process the input data and present the bowling score card
class BowlingController

	# Process the input file data and present the bowling score card if the input
	# offers valid players.
	#
	# Can print players with no shots or incomplete shots
	def self.process
		raw_data = GenerateController.generate_data
		raw_data = InputFileController.get_raw_data if raw_data.nil?

		# next line is RAM friendly
		PlayerScore.digest_input_line raw_data.shift while(raw_data.size > 0)
		
		if PlayerScore.player_list.keys.size > 0
			OutputFileController.write BowlingView.print_scores PlayerScore.player_list
		end
	end
end
