require File.expand_path './before_specs.rb', __dir__
require File.expand_path '../src/controllers/input_file_controller.rb', __dir__
require File.expand_path '../src/models/player_score.rb', __dir__

RSpec.describe PlayerScore, '#initialize' do
	context 'Within the input process players are build' do
		it 'should create a PlayerScore object' do
			p = PlayerScore.new 'MyName'
			expect(p.class.name).to eq 'PlayerScore'
			# check public attributes
			expect(p.name).to eq 'MyName'
			expect(p.frames).to eq [[]]
			
		end
	end
end
log = nil
RSpec.describe PlayerScore, '.digest_input_line' do
	before(:context) do
		PlayerScore.reset_scores
		Debug.clean_log()
		InputFileController.set_input_file File.expand_path '../fixtures/data_4_digest_input_line.txt', __dir__
		raw_data = InputFileController.get_raw_data
		raw_data.each {|input_line| PlayerScore.digest_input_line input_line}
		log = Debug.log
		puts log
  end
	context 'With a "valid" input' do
		it 'Players should be created just one time' do
			expect(PlayerScore.player_list[:RepeatedName].class.name).to eq 'PlayerScore'
			expect(PlayerScore.player_list[:RepeatedName].frames).to eq [[0, 0], [0]]
		end
		it 'Strikes should fill-block a frame' do
			expect(PlayerScore.player_list[:StrikePlayer].frames).to eq [[10], [4]]
		end
		it 'Should warning when a frame take more than 10 pines' do
			expect(log).to include '_DBG: warning_overflow_pins·CheaterPines, frame:0, pins: 16, 1'
			expect(PlayerScore.player_list[:CheaterPines].frames).to eq [[8,0],[]]
		end
		it 'Should ignore a player when play extra frames or extra shots' do
			expect(log).to include '_DBG: warning_overflow_pins·CheaterPines, frame:0, pins: 16, 1'
			expect(PlayerScore.player_list[:CheaterFrames].frames).to eq [
				[10], [10], [10], [10], [10], [10], [10], [10], [10], [5, 5, 9],
			]
		end
		it 'Should grant the extra shot to a player with the 10\' strike/spare' do
			expect(PlayerScore.player_list[:MheeBonusShot].frames).to eq [
				[10], [10], [10], [10], [10], [10], [10], [10], [10], [5, 5, 5],
			]
			expect(PlayerScore.player_list[:GoodBonusShot].frames).to eq [
				[10], [10], [10], [10], [10], [10], [10], [10], [10], [10, 3, 3],
			]
		end
		it 'Should warning a player when play the extra shot without earning' do
			# expect(log).to include '_DBG: warning_overflow_extra_shot·CheaterPines, frame: 10, shots: [2,2], 10'
			expect(PlayerScore.player_list[:CheaterBonusShot].frames).to eq [
				[10], [10], [10], [10], [10], [10], [10], [10], [10], [2, 2],
			]
		end
	end
end

RSpec.describe PlayerScore, '#get_score' do
	before(:context) do
		PlayerScore.reset_scores
		Debug.clean_log()
		InputFileController.set_input_file File.expand_path '../fixtures/data_4_get_score.txt', __dir__
		raw_data = InputFileController.get_raw_data
		raw_data.each {|input_line| PlayerScore.digest_input_line input_line}
  end
	context 'With players with some shots' do
		it 'Score should calculed in any of the 10 frames' do
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 0).to eq 30
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 1).to eq 60
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 2).to eq 90
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 3).to eq 120
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 4).to eq 150
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 5).to eq 180
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 6).to eq 210
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 7).to eq 240
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 8).to eq 270
			expect(PlayerScore.player_list[:GodlikePlayer].get_score 9).to eq 300
			expect(PlayerScore.player_list[:GodlikePlayer].get_score).to eq 300
		end
		it 'Frame pins down should be added if those was less to 10' do
			expect(PlayerScore.player_list[:NormalPlayer].get_score 0).to eq 7
			expect(PlayerScore.player_list[:Me].get_score).to eq 0
		end
		it 'Spare should add the next shot to the score' do
			expect(PlayerScore.player_list[:GoodPlayer].get_score 0).to eq 16
		end
		it 'Strike should add the next two shots to the score' do
			expect(PlayerScore.player_list[:ÜberPlayer].get_score 0).to eq 29
			expect(PlayerScore.player_list[:ExcelentPlayer].get_score 0).to eq 19
		end
		it 'The perfect score should be 300' do
			expect(PlayerScore.player_list[:GodlikePlayer].get_score).to eq 300
		end
	end
end
