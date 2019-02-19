# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require_relative './controllers/debug_controller.rb'
require_relative './controllers/error_log_controller.rb'

# just a set of alias for the most common of the outputs
Debug = DebugController
Error = ErrorLogController
