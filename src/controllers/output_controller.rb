# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co

# This class handle the output file
class OutputFileController

	# Set the file route of the output
	# will check and alert if the file is found
	# @param file_route [Strign, #read] the file route of the output file
	def self.set_output_file(file_route = :NO_FILE_OUTPUT)
		@@output_file_route = File.absolute_path file_route
		if File.exist? @@output_file_route
			Error.print :warning_output_file_found, @@output_file_route
		else
			Debug.print "Will output in file #{@@output_file_route}"
		end
	end

	# Will print the data in STDOUT or a file
	# @param data [Strign, #read] the output data
	# @param data [file_route, #read] the output file route
	def self.write(data, file_route = nil)
		if @@output_file_route == :NO_FILE_OUTPUT
			puts data
		else
			file_route ||= @@output_file_route
			File.open(file_route, 'w') do |f|
				Debug.print "Writing output in file #{f.path}"
				f.syswrite data
			end
		end
	end
end
