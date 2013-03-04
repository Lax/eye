# encoding: utf-8
# require 'sinatra'

require './helpers.rb'
require './lib/gmond.rb'

# AppController
class AppController < Sinatra::Base
	enable :sessions
	set :show_exceptions, true if development?
	set :raise_errors, false

	helpers Sinatra::HTMLEscapeHelper

	helpers do
	end

	before do
	end

	error do
		'Sorry there was a nasty error'
	end

	get '/' do
		haml :index
	end

	get '/traffic' do
		haml :traffic
	end

	get '/nuts' do
		hostname = params[:hostname] ? params[:hostname] : '127.0.0.1'
		@data = Eye::Gmond.fetch(hostname, 8649)
		haml :nuts
	end
end
