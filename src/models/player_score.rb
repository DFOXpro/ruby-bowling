# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require './_alias.rb'

# This class digest the data to a player list with the bowling shots and scores
#
# it store the player list in a singleton array
class PlayerScore

	# Total frames in a regular bowling game
	TOTAL_FRAMES = 10
	# Total pines in a regular bowling game
	TOTAL_PINES = 10

	# Total shots/tries in the first 9 frames of a bowling game
	NORMAL_FRAME_SHOTS = 2
	# Maximum shots/tries in the last frame of a bowling game
	FINAL_FRAME_SHOTS = 3

	# Standar to use in the scoring method
	SCORE_MODE_TRADITIONAL = :SCORE_MODE_TRADITIONAL
	# (Not implemented) other Standar to bowling scoring method
	SCORE_MODE_WBS = :SCORE_MODE_WBS

	# Array<PlayerScore> all valid players with their shots
	# @!attribute [r] player_list
	# @singleton
	@@player_list = {}

	# control variable for the data digest process
	@@previous_player = nil

	# This is the constructor of the player perse, that will give you access to
	# the scores and shots of the player
	# @param name[String] Name of the player
	def initialize(name)
		Debug.print "New player: #{name}"
		@name = name
		@frames = [[]]

		# control flag variables for optimization in diggest process
		@frame_shots = 0
		@current_frame = 0 # @@current_frame # when join late in game ?
		@current_frame_pins = 0
	end

	# Intended for testing, if you need to make a complete game after an already
	# processed one, use this method
	def self.reset_scores
		@@player_list = {}
		@@previous_player = nil
	end

	# Diggest a sanitized input line
	# Add a player to the roaster if not found and add the given shot result to his game
	# @param input_line [Array[player_name<String>, shot_result<String>(Integer 0 to 10 or 'F')]]
	def self.digest_input_line(input_line)
		player_name = input_line[0]
		player_name_s = player_name.to_sym
		shot_score = input_line[1]
		if @@player_list[player_name_s].nil?
			@@player_list[player_name_s] = PlayerScore.new player_name
		end
		@@player_list[player_name_s].add_shot_score shot_score
	end

	# Add a shot result to a player
	# will ignore all invalid shots like (i.e.): 11 frame, 3th(not earned) or 4th shot
	# @param new_shot_score [String(Integer 0 to 10 or 'F')]
	def add_shot_score(new_shot_score)
		new_shot_score = validate_shot_score new_shot_score
		if @@previous_player != self
			# if(
			# 	not @@previous_player.nil? and
			# 	@@previous_player.current_frame_pins < 10 and
			# 	@@previous_player.frame_shots < 1
			# )
			# 	Error.print :warning_missin_shot, @@previous_player.name
			# end
			@@previous_player = self
		end

		#  validate turn and total frame shots
		@frame_shots += 1
		if(
			( # first 9 frames
				@current_frame_pins < TOTAL_PINES and
				@frame_shots <= NORMAL_FRAME_SHOTS and
				@current_frame < TOTAL_FRAMES
			) or ( # 10 frame
				@current_frame + 1 == TOTAL_FRAMES and
				@frame_shots <= FINAL_FRAME_SHOTS
			)
		)
			add_valid_score_to_frame(new_shot_score) if not ( # the extra shot
				@frame_shots == FINAL_FRAME_SHOTS &&
				frame_pins(@current_frame)<TOTAL_PINES
			)
			set_end_of_frame() if(
				(
					@frame_shots >= NORMAL_FRAME_SHOTS or
					new_shot_score == TOTAL_PINES
				) and
				@current_frame + 1 < TOTAL_FRAMES
			)
		end
	end

	# Give you the player score of the given frame
	# @param frame[Integer(0 to 9)] max frame to evaluate the score
	# @param type[Symbol] (not impĺemented) method to calculate the score
	# @return [Integer] Player score up to given frame
	def get_score(frame = TOTAL_FRAMES, type = SCORE_MODE_TRADITIONAL)
		total_score = 0
		frame_i = 0
		while(frame_i < frame + 1)
			frame_score = frame_pins(frame_i)
			if strike? frame_i
				frame_score += (
					strike?(frame_i + 1) ?
						frame_pins(frame_i + 1, 2) + (
							strike?(frame_i + 2) ? TOTAL_PINES : frame_pins(frame_i + 2, 2)
						) :
						frame_pins(frame_i + 1, 2)
				)
			elsif spare?(frame_i)
				frame_score += (
					strike?(frame_i + 1) ?
					TOTAL_PINES :
					parce_score(
						frames[frame_i + 1].nil? ?
						0 :
						frames[frame_i + 1][0]
					)
				)
			end
			total_score += frame_score
			frame_i += 1
		end
		return total_score
	end

	# gets & sets

	# A getter of the singleton player_list, this is the data send to BowlingView
	# @!attribute [r] player_list
	def self.player_list
		return @@player_list
	end

	# @!attribute [r] name
	def name
		return @name
	end

	# @!attribute [r] frames
	def frames
		return @frames
	end

	# @return [Boolean] it was a strike in the given frame
	def strike?(frame_i)
		return (
			(not @frames[frame_i].nil?) and
			@frames[frame_i][0] == TOTAL_PINES
		)
	end

	# @return [Boolean] it was a spare in the given frame
	def spare?(frame_i)
		return (
			(not @frames[frame_i].nil?) and
			frame_pins(frame_i, NORMAL_FRAME_SHOTS) == TOTAL_PINES
		)
	end

	private

	# sum the pins down of the given shots in the given frame
	def frame_pins(frame_i, valid_shots = FINAL_FRAME_SHOTS)
		r = 0
		return r if @frames[frame_i].nil?
		@frames[frame_i].each_index do |shot_i|
			r += parce_score(@frames[frame_i][shot_i]) if shot_i < valid_shots
		end
		return r
	end

	# after verification will add the shot score to the current frame of the player
	def add_valid_score_to_frame(new_shot_score)
		@frames[@current_frame] << new_shot_score
		@current_frame_pins += parce_score new_shot_score
		Debug.print "#{@name} [f#{@current_frame} p#{@current_frame_pins}] (t#{@frame_shots} s#{new_shot_score})"
	end

	# after verification will end the current_frame and start another
	def set_end_of_frame
		Debug.print( "#{@name} frame end")
		@current_frame += 1
		@current_frame_pins = 0
		@frame_shots = 0
		@frames[@current_frame] = []
	end

	# A score can be a Foul and will be processed like Zero, this method prevent
	# String > Integer error
	def parce_score(shot_score)
		shot_score === 'F' ? 0 : shot_score
	end

	# Will check shenanigans like extra pins or any(??) non valid input
	def validate_shot_score(new_shot_score)
		# normalize input
		is_fault = new_shot_score === "F\n"
		new_shot_score = new_shot_score.to_i # ignore other strings of floats
		pins_down = @current_frame_pins + new_shot_score
		if(
			pins_down > TOTAL_PINES and
			@current_frame + 1 < TOTAL_FRAMES
		)
			Error.print :warning_overflow_pins, "#{@name}, frame:#{@current_frame}, pins: #{pins_down}, #{@frame_shots}"
			new_shot_score = 0
		end
		return is_fault ? 'F' : new_shot_score
	end
end