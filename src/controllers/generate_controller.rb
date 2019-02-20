# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join File.dirname(__FILE__), '../_alias.rb'
require File.join File.dirname(__FILE__), '../models/player_score.rb'
require File.join File.dirname(__FILE__), './output_controller.rb'

# This class create random data to process
class GenerateController

	# How many player will play if data is generated
	@@generate_file_route = :NO_FILE_OUTPUT
	@@generate_total_players = DEFAULT_TOTAL_PLAYERS
	@@should_generate_data = false
	@@should_generated_data_be_process = true

	# Set the file route of the generated input
	# will check and alert if the file is not found
	# @param file_route [Strign, #read] the file route of the generated file
	def self.set_input_file(file_route = :NO_FILE_OUTPUT)
		@@should_generate_data = true
		if file_route == :NO_FILE_OUTPUT
			Debug.print "Will generate data in RAM only"
			return
		end
		@@generate_file_route = File.absolute_path file_route
		if File.exist? @@generate_file_route
			Error.print :warning_generate_found, @@generate_file_route
		else
			Debug.print "Will generate file #{@@generate_file_route}"
		end
	end

	def self.set_input_file_no_process(file_route = :NO_FILE_OUTPUT)
		set_input_file(file_route)
		@@should_generated_data_be_process = false
	end

	# Set the total player that will be generated
	# @param total_players [Integer, #read]
	def self.set_players(total_players = DEFAULT_TOTAL_PLAYERS)
		Debug.print "Set #{total_players} players in generated data"
		@@generate_total_players = total_players.to_i
	end

	# If requested will generate random valid data to be processed
	# @return [Array] or [Nil] player, shotscore
	def self.generate_data
		return nil if not @@should_generate_data
		generated_data = []
		player_names = generate_random_names
		player_shots = {}
		player_names.each {|player| player_shots[player] = generate_shots}

		# this part is suboptimal for code but 1·1 to example input file
		# and it's not slow in the end
		PlayerScore::TOTAL_FRAMES.times do # |frame_i|
			player_names.each do |player|
				(player_shots[player].shift).each do |shot|
					generated_data << [player, shot]
				end
			end
		end
		return @@should_generated_data_be_process ? generated_data : []
	end

	private

	# Get names from names.yml and if needed, it's goin to generate the missing ones
	# @return [Array<String>]
	def self.generate_random_names
		player_names = YAML.load_file(
			File.join File.dirname(__FILE__), "../locales/names.yml"
		)["names"]
		current_players = []
		if @@generate_total_players < player_names.size
			current_players = player_names.sample @@generate_total_players
		else
			require 'securerandom'
			current_players = player_names
			(@@generate_total_players - player_names.size).times do |i|
				posible_name = current_players[0]
				while(
					current_players.include? posible_name
				) do
					posible_name = SecureRandom.alphanumeric
				end
				current_players << posible_name
			end
		end
		return current_players
	end

	VALID_SHOT = [*(0..PlayerScore::TOTAL_PINES), 'F']
	# Create a valid and complete shot list
	# @return [Array<Number>]
	def self.generate_shots
		total_shots = []
		PlayerScore::TOTAL_FRAMES.times do |frame_i|
			frame_shots = [VALID_SHOT.sample] # first shot

			frame_shots << complete_shotLine(frame_shots[0]) if(
				(not PlayerScore.strike? frame_shots) and
				frame_i+1 < PlayerScore::TOTAL_FRAMES
			)
			if( # last frame 2nd & 3th shot
				frame_i+1 == PlayerScore::TOTAL_FRAMES
			)
				frame_shots << last_frame_shot(frame_shots) # 2nd in last frame
				frame_shots << last_frame_shot(frame_shots) if ( # Bonus shot
					PlayerScore.strike?(frame_shots) or
					PlayerScore.spare? frame_shots
				)
			end
			total_shots << frame_shots
		end
		return total_shots
	end
	def self.last_frame_shot(frame_shots)
		if PlayerScore.strike? [frame_shots.last]
			return VALID_SHOT.sample
		else
			return complete_shotLine frame_shots.last
		end
	end
	def self.complete_shotLine(first_shot)
		[
			*(0..(PlayerScore::TOTAL_PINES - first_shot.to_i)), 'F'
		].sample
	end

end
