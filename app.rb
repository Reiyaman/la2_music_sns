require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'dotenv/load'

enable :sessions #セッション機能

helpers do #ログイン中のユーザー情報取得
    def current_user
        User.find_by(id: session[:user])
    end
end

get '/' do
    erb :index
end

get '/sign_up' do
    erb :sign_up
end

post '/sign_up' do
    user = User.create(
        name: params[:name],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        profile: params[:profile])
    if user.persisted? #データベースに保存されたかどうか
        session[:user] = user.id
        redirect '/search'
    else
        redirect '/'
    end
end

post '/sign_in' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
        redirect '/search'
    else
        redirect '/'
    end
end

get '/sign_out' do
    session[:user] = nil
    redirect '/'
end

get '/search' do
    erb :search
end

get '/home' do
    erb :home
end

post '/delete/:id' do
    song = Song.find(params[:id])
    song.destroy
    redirect 'home'
end

get '/edit/:id' do
    erb :edit
end

post '/update/:id' do
    
    redirect '/home'
end