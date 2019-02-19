# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require_relative '../localization.rb'

# This class will print the version info
class VersionView < Localization

	# Prints the version info within a locale template
	def self.print(
		program_name,
		version,
		author,
		licence
	)
		super(:version_txt,{
			program_name: program_name,
			version: version,
			author: author,
			licence: licence
		})
	end
end
