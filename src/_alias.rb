# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join File.dirname(__FILE__), './controllers/debug_controller.rb'
require File.join File.dirname(__FILE__), './controllers/error_log_controller.rb'

# just a set of alias for the most common of the outputs
Debug = DebugController
Error = ErrorLogController
