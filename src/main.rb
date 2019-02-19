#!/usr/bin/env ruby
# @author Daniel Zorro (DFOXpro) drzorrof+ruby-bowling at unal dot edu dot co
require_relative './router.rb'
require_relative './variables.rb'

BowlingController.process if Router.digest_arguments ARGV
