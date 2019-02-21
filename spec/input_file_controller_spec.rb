require File.expand_path './before_specs.rb', __dir__
require File.expand_path '../src/controllers/input_file_controller.rb', __dir__

src_folder = File.expand_path('../src', __dir__)
RSpec.describe InputFileController, '.set_input_file' do
	before(:example) do
		InputFileController.set_input_file
		Debug.clean_log()
  end
	context 'With existant input set' do
		it 'should search for a existant file, and be OK' do
			InputFileController.set_input_file "#{src_folder}/_alias.rb"
			expect(Debug.log).to include("_DBG: #{src_folder}/_alias.rb input file found")
		end
	end
	context 'With non existant custom input set' do
		it 'should search for a non existant file, and warning us' do
			InputFileController.set_input_file "#{src_folder}/ethereal file.lol"
			expect(Debug.log).to include("_DBG: warning_input_not_found·#{src_folder}/ethereal file.lol")
		end
	end
end
RSpec.describe InputFileController, '.get_raw_data' do
	before(:example) do
		InputFileController.set_input_file
		Debug.clean_log()
	end
	context 'With no present custom input' do
		it 'should warning input file not found and return an empty array' do
			InputFileController.set_input_file "#{src_folder}/ethereal file.lol"
			r = InputFileController.get_raw_data
			expect(Debug.log).to include("_DBG: error_input_not_found·#{src_folder}/ethereal file.lol")
			expect(r).to eq []
		end
	end
	context 'With no custom input' do
		it 'should search for a default input file' do
			InputFileController.get_raw_data
			expected_output = ""
			if File.exist? "#{Dir.pwd}/game.txt"
				expected_output = "_DBG: Reading input file: #{Dir.pwd}/game.txt"
			else
				expected_output = "_DBG: error_input_not_found·#{Dir.pwd}/game.txt"
			end
			expect(Debug.log).to include expected_output
		end
	end
	context 'With custom input' do
		it 'should search this input file' do
			InputFileController.set_input_file "#{src_folder}/game.txt"
			InputFileController.get_raw_data
			expect(Debug.log).to include("_DBG: Reading input file: #{src_folder}/game.txt")
		end
	end
	context 'With valid input' do
		it 'should return an array of arrays(name, score)' do
			InputFileController.set_input_file File.expand_path '../fixtures/valid_input_file.txt', __dir__
			r = InputFileController.get_raw_data
			expect(r).to eq [["a", "0\n"], ["Multiple names", "1\n"], ["東京都", "2\n"], ["Paraît", "3\n"], ["Español", "4\n"], ["€µrøþæ", "5\n"], ["Æ§ıæ", "6\n"], ["Áḿèrïĉå", "7\n"], ["1", "8\n"], ["\"\"", "9\n"], ["`", "10\n"], ["f", "F"]]
		end
	end
	context 'With invalid input' do
		it 'should warning each broken line and skip the line' do
			InputFileController.set_input_file File.expand_path '../fixtures/invalid_input_file.txt', __dir__
			r = InputFileController.get_raw_data
			# puts Debug.log
			expect(Debug.log).to include(
				"_DBG: warning_input_line_invalid·\n",
				"_DBG: warning_input_line_invalid·JustTheName\n",
				"_DBG: warning_input_line_invalid·Two	tabs	1\n",
				"_DBG: warning_input_line_invalid·NegativeScore	-1\n",
				"_DBG: warning_input_line_invalid·OverScore	11\n",
				"_DBG: warning_input_line_invalid·InvalidStringScore	a\n",
				'_DBG: warning_input_line_invalid·InvalidStringCaseScore	f'
			)
			expect(r).to eq []
		end
	end
end