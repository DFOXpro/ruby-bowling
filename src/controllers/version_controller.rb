# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join File.dirname(__FILE__), '../views/version_view'

# This class will print the version info
class VersionController

	# Prints the version info within a locale template
	# it's using the global program description variables
	def self.show_version
		VersionView.print(
			PROGRAM_NAME,
			VERSION,
			AUTHOR,
			LICENCE
		)
	end
end
