# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
class OutputFileController
	def self.print(text)
		puts text
	end

	def self.set_output_file(file_route = :NO_FILE_OUTPUT)
		@@output_file_route = File.absolute_path file_route
		if File.exist? @@output_file_route
			Error.print :warning_output_file_found, @@output_file_route
		else
			Debug.print "Will output in file #{@@output_file_route}"
		end
	end


	def self.write(data, file_route = nil)
		file_route ||= @@output_file_route
		File.open(file_route, 'w') do |f|
			Debug.print "Writing output in file #{f.path}"
			f.syswrite(data)
		end
	end
	
end
