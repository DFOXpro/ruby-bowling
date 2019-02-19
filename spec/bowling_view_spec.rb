require_relative './before_specs.rb'
require_relative '../src/controllers/input_file_controller.rb'
require_relative '../src/models/player_score.rb'
require_relative '../src/views/bowling_view.rb'

def _process_data(input_file)
	InputFileController.set_input_file input_file
	raw_data = InputFileController.get_raw_data
	raw_data.each {|input_line| PlayerScore.digest_input_line input_line}
	return BowlingView.print_scores PlayerScore.player_list
end

RSpec.describe BowlingView, '.print_scores' do
	before(:example) do
		PlayerScore.reset_scores
		Debug.clean_log()
  end
	context 'With players with some shots' do
		it 'Should print a bowling score card' do
			output = _process_data '../fixtures/game.txt'
			expected_output = "Frame		1		2		3		4		5		6		7		8		9		10
Jeff
Pinfalls		X	7	/	9	0		X	0	8	8	/	F	6		X		X	X	8	1
Score		20		39		48		66		74		84		90		120		148		167
John
Pinfalls	3	/	6	3		X	8	1		X		X	9	0	7	/	4	4	X	9	0
Score		16		25		44		53		82		101		110		124		132		151
"
			expect(output).to eq expected_output
		end
		it 'Should print the perfect bowling score card' do
			output = _process_data '../fixtures/game_perfect.txt'
			expected_output = "Frame		1		2		3		4		5		6		7		8		9		10
Carl
Pinfalls		X		X		X		X		X		X		X		X		X	X	X	X
Score		30		60		90		120		150		180		210		240		270		300
"
			expect(output).to eq expected_output
		end
	end
end
