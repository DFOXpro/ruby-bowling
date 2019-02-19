# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require_relative '../localization.rb'

# This class will print errors in STDERR
class ErrorLogView < Localization

	# Will print a localized version of the error with the given data
	def self.print(error_id, error_data)
		super error_id, error_data, STDERR
	end
end
