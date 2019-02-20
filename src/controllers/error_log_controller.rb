# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join File.dirname(__FILE__), '../views/error_log_view'
require File.join File.dirname(__FILE__), '../_alias'

# This class will show errors catch/pop in this program
class ErrorLogController

	# The output used to show the errors can be ErrorLogView or Debug
	@@error_output = ErrorLogView

	# Set the output to debug, to use in testing environment
	def self.set_error_2_debub
		@@error_output = Debug
		Debug.print 'Enable debug errors'
	end

	# Method to use when an error is detected
	# @param error_id [Symbol, #read] an Id to relate with a more descriptive locale
	# @param error_data [Hash, #read] data that pop this error, may be printed in the locale
	def self.print(error_id, error_data)
		@@error_output.print(error_id, error_data)
		return nil
	end
end
