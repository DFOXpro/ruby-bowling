# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join File.dirname(__FILE__), '../_alias.rb'

class GenerateController
	def self.set_input_file(file_route)
		puts "inputFileController.set_input_file: #{file_route}"
		@@generate_file_route = flie_route
		if File.exist?(@@generate_file_route)
			Error.print :warning_generate_found, @@generate_file_route
		else
			Debug.print "Will generate file found #{@@generate_file_route}"
		end
	end
	def self.set_players(total_players)
		Debug.print "Set #{total_players} players in generated data"
		@@generate_file_route = total_players
	end
	# private
	
end
