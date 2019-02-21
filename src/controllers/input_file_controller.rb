# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join(File.dirname(__FILE__), '../_alias.rb')
require File.join File.dirname(__FILE__), '../variables.rb'

# This class handle the input file and give an tokenized array of the lines in the file
class InputFileController

	# The file route that will be processed as input
	@@input_file_route = DEFAULT_INPUT_FILE

	# Set the file route of the input
	# will check and alert if the file is not found
	# @param file_route [Strign, #read] the file route of the input file
	def self.set_input_file(file_route = DEFAULT_INPUT_FILE)
		Debug.print "inputFileController.set_input_file: #{file_route}"
		@@input_file_route = File.absolute_path file_route
		if File.file? @@input_file_route
			Debug.print "#{@@input_file_route} input file found"
		else
			Error.print :warning_input_not_found, @@input_file_route
		end
	end

	# Will try to read the @@input_file_route and return a tokenized and sanitized
	# array of each line of the file.
	#
	# If the file is not found will pop an error and return an empty array
	def self.get_raw_data
		raw_data = []
		total_readed_lines = 0
		if File.file? @@input_file_route
			Debug.print "Reading input file: #{@@input_file_route}"
			File.foreach(@@input_file_route) do |line|
				total_readed_lines += 1
				tokenized = line.split("	")
				if(
					# not line[0] === '#' and # enable comments
					tokenized.size === 2 and
					tokenized[1] =~ /(^[0-9]$|F|10)/
				)
					raw_data << tokenized
				else
					Error.print :warning_input_line_invalid, line
				end
			end
		else
			Error.print :error_input_not_found, @@input_file_route
		end
		Debug.print "Total readed lines: #{total_readed_lines}"
		return raw_data
	end
end
