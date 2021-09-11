require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models'
require 'dotenv/load'
require 'open-uri'
require 'json'
require 'net/http'

enable :sessions #セッション機能

helpers do #ログイン中のユーザー情報取得
    def current_user
        User.find_by(id: session[:user])
    end
end

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV['CLOUD_NAME']
        config.api_key = ENV['CLOUDINARY_API_KEY']
        config.api_secret = ENV['CLOUDINARY_API_SECRET']
    end
end

get '/' do
    erb :index
end

get '/sign_up' do
    erb :sign_up
end

post '/sign_up' do
    img_url = ''
    if params[:profile]
        img = params[:profile]
        tempfile = img[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
    end
    
    user = User.create({
        name: params[:name],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        profile: img_url
    })
    
    if user.persisted? #データベースに保存されたかどうか
        session[:user] = user.id
        puts session[:user]
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
    @songs = ""
    
    erb :search
end

get '/home' do
    erb :home
end

post '/delete/:id' do
    song = Song.find(params[:id])
    song.destroy
    redirect '/home'
end

get '/edit/:id' do
    erb :edit
end

post '/update/:id' do
    
    redirect '/home'
end

post '/search/result' do
    artist = params["artist"]
    uri = URI("https://itunes.apple.com/search")
    uri.query = URI.encode_www_form({ 
        term: artist,
        country: "JP",
        media: "music",
        limit: 10
    })
    
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    @songs = json["results"]
    
    erb :search
end