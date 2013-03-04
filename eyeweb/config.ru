#!/usr/bin/env ruby -w
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'rubygems'
require 'bundler'
Bundler.require

require './dm_loader.rb'
require './app.rb'

map "/" do
	run AppController
end
