#!/bin/sh
bundle install
rspec --format html ../spec/*_spec.rb  --out ../spec/results.html
