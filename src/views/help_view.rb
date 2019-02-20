# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join File.dirname(__FILE__), '../localization.rb'

# This class will print the help info
class HelpView < Localization

	# Prints the help info within a locale template
	def self.print(program_name, default_input_file)
		super(:help_txt,{
			program_name: program_name,
			default_input_file: default_input_file
		})
	end
end
