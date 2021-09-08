require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'dotenv/load'

enable :sessions

get '/' do
    erb :index
end

get '/sign_up' do
    erb :sign_up
end

post 'signup' do
    
    redirect '/'
end