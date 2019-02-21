#!/usr/bin/env ruby
# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require File.join File.dirname(__FILE__), './router.rb'
require File.join File.dirname(__FILE__), './variables.rb'

def main(args)
	BowlingController.process if Router.digest_arguments args
end
main ARGV

