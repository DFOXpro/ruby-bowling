# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join File.dirname(__FILE__), './_alias.rb'
Dir[File.join(File.dirname(__FILE__), "./controllers/*_controller.rb")].each do |controller_file|
	require_relative controller_file
end

# This class process all the text _arguments_ given to the program.
#
# All available via <program binary> <arguments ...>
# (i.e.): ./ruby-bowling --debug -p 8 G my\ game.txt
class Router
	class << self
		# Definitions of all valid argument of this program,
		# by accessed by -<key> or <key(uppercase)> or --<key.long_param>
		# (i.e.): -h H --help all point to h argument definition
		@@arguments_definition = {
			v: {
				# short_param: 'i' # same as id
				long_param: 'version',
				digester_controller: VersionController,
				digester_method: 'show_version',
				digester_args: true,
				unique?: true
			},
			h: {
				long_param: 'help',
				digester_controller: HelpController,
				digester_method: 'show_help',
				digester_args: nil,
				unique?: true
			},
			d: {
				long_param: 'debug',
				digester_controller: DebugController,
				digester_method: 'enable_debug',
				digester_args: nil,
			},
			g: {
				long_param: 'generate',
				digester_controller: GenerateController,
				digester_method: 'set_input_file',
				digester_args: true
			},
			p: {
				long_param: 'generate-total-players',
				digester_controller: GenerateController,
				digester_method: 'set_players',
				digester_args: true
			},
			i: {
				long_param: 'input-file',
				digester_controller: InputFileController,
				digester_method: 'set_input_file',
				digester_args: true,
			},
			o: {
				long_param: 'output-file',
				digester_controller: OutputFileController,
				digester_method: 'set_output_file',
				digester_args: true
			}
			# any_other_option: {
			# 	long_param: '__error',
			# 	digester_controller: ErrorLogController,
			# 	digester_method: 'print_invalid_argument'
			# }
		}


		# This static method get the terminal arguments and define which actions should be exec.
		#
		# @param args [Array<String>, #read] Each parameter given to the program
		# @return [Boolean] If no unique actions like version or help, the bowling part should be exec
		def digest_arguments(args)
			@actions_to_exec = []
			digest_arguments_definitions()
			_digest_arguments args
			should_exec_bowling_logic = true
			@actions_to_exec.each do |action|
				should_exec_bowling_logic = false if action[:unique?]
				if action[:digester_args].nil?
					action[:digester_controller].public_send action[:digester_method]
				else
					action[:digester_controller].public_send(
						action[:digester_method],
						action[:digester_args]
					)
				end
			end
			return should_exec_bowling_logic
		end

		private

		# compare the arguments with the available arguments definition in the
		# defacto variations (i.e.): --option, -o, O, <file>.
		# if a valid action is found, will add this to a list of actions to do before
		# the bowling logic,
		# @param args [Array<String>, #read] Each parameter given to the program
		def _digest_arguments(args)
			if(
				args.size == 1 and
				not args[0][0] == '-' and
				not (args[0].chars.all? { |c|
					@@arguments_definition.keys.include?(c.swapcase.to_sym)
				})
			)
				digest_posible_arg(@@arguments_definition['i'.to_sym], args[0], args[0])
				return
			end
			return if args.length == 0
			@ignore_next_argument = false
			args.each_with_index do |arg, arg_index|
				next_arg = args[arg_index + 1]
				if @ignore_next_argument
					@ignore_next_argument = false
				elsif(
					arg[0, 2] == '--'
				) # it's long arg
					if(arg.size == 0)
						Error.print :invalid_argument_blank, arg
					else
						posible_arg = @@arguments_definition[arg]
						digest_posible_arg(posible_arg, next_arg, arg)
					end
				elsif(
					arg[0] == '-'
				) # it's short arg
					if(arg.size > 2)
						Error.print :error_invalid_argument_concat, arg
					elsif(arg.size == 1)
						Error.print :error_invalid_argument_blank, arg
					else
						posible_arg = @@arguments_definition[arg[1].to_sym]
						digest_posible_arg(posible_arg, next_arg, arg)
					end
				elsif(
					arg.size > 0
				) # it's really short arg
					arg.chars.each do |_arg|
						posible_arg = @@arguments_definition[_arg.downcase.to_sym]
						digest_posible_arg(posible_arg, next_arg, _arg)
					end
				end
				# puts "#{arg_index}: #{arg} (#{next_arg})"
			end
		end

		# Preventing redundant code definitions, this function will populate the
		# arguments definition with the long version of the argument (i.e.):
		# if -h will add --help
		def digest_arguments_definitions
			return if not @@arguments_definition['--version'].nil?
			@@arguments_definition.keys.each { |key|
				value = @@arguments_definition[key]
				@@arguments_definition["--#{value[:long_param]}"] = value
			}
		end

		# This static method get the terminal arguments and define which actions should be exec.
		#
		# @param argument_definition [Hash, #read] value from @@arguments_definition
		# @param digester_args [String, #read] the companion argument (i.e.): file route or number
		# @return [Hash] Action to exec
		def define_action_to_exec(argument_definition, digester_args = nil)
			action_to_exec = {
				digester_controller: argument_definition[:digester_controller],
				digester_method: argument_definition[:digester_method],
				unique?: argument_definition[:unique?]
				# digester_args: # see below
			}
			if argument_definition[:digester_args]
				action_to_exec[:digester_args] = digester_args
				@ignore_next_argument = true
			end
			return action_to_exec
		end

		# Pop error if this argument is not within the @@arguments_definition
		# else try to add to the @actions_to_exec
		def digest_posible_arg(posible_arg, arg_value, arg_id)
			if posible_arg.nil?
				Error.print :error_invalid_argument, arg_id
			else
				return if(
					@actions_to_exec.size === 1 and
					@actions_to_exec[0][:unique?]
				)
				@actions_to_exec << define_action_to_exec(posible_arg, arg_value)
			end
		end
	end
end
