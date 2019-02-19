#!/bin/sh
bundle install
cd ..
rm -Rv .yardoc/; rm -Rv ./doc; yard doc './src/**/*' - README LICENSE
