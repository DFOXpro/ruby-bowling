# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require_relative './error_log_controller'

# This class if enable will print debug info, intended for testing
class DebugController

	# When true will show all debug messages
	@@enable_debug = false

	# The output used to show the errors can be STDOUT or DebugOutputAttribute object
	@@debug_output = STDOUT

	# Enable show debug messages
	def self.enable_debug
		@@enable_debug = true
		Debug.print 'Enabled'
	end

	# Method to use to show a debug message, note this is not localized
	# @param *args [Any, #read] any info/descriptor/variable to show in the debug message
	def self.print(*args)
		@@debug_output.puts "_DBG: #{args.join('·')}" if @@enable_debug
		return nil
	end

	# @private
	# This class will save all debug messages in the program memory instead the STDOUT
	# intended for testing usage
	class DebugOutputAttribute
		def initialize
			@log = []
		end
		def puts(*args)
			@log += args
		end
		def log
			return @log
		end
		def clean_log
				@log = []
		end
	end
	private_constant :DebugOutputAttribute

	# Set de debug environment to test so all debug and error messages will be stored
	# in the program memory via Debug.log
	def self.enable_testing
		enable_attribute_log()
		enable_debug()
		ErrorLogController.set_error_2_debub()
	end

	# Will replace STD to DebugOutputAttribute in the debug output to store
	# the debug messages in the program
	def self.enable_attribute_log
		@@debug_output = DebugOutputAttribute.new()
		Debug.print 'Enable attribute log'
	end

	# Give access to DebugOutputAttribute.log for testing purpose
	def self.log
			return @@debug_output.log
	end

	# Will clear all stored debug messages if enable_attribute_log
	def self.clean_log
			return @@debug_output.clean_log
	end
end
