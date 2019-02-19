# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require_relative '../views/help_view'

# This class will print the help info
class HelpController

	# Prints the help info within a locale template
	# it's using the global program description variables
	def self.show_help
		HelpView.print(
			PROGRAM_NAME.downcase,
			DEFAULT_INPUT_FILE
		)
	end
end
