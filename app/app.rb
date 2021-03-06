require 'securerandom'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'
require './app/data_mapper_setup'
require './lib/send_reset_email'

class BookmarkManager < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  set :session_secret, 'super secret'
  use Rack::MethodOverride

  get '/' do
    redirect '/users/new'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    all_tags = params[:tag].split(' ')
    all_tags.each do |tag|
      tag = Tag.create(text: tag)
      link.tags << tag
    end
    link.save
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(text: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
                     password: params[:password],
                     password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(email: params[:email], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session.clear
    erb :'sessions/goodbye'
  end

  get '/password_reset' do
    erb :'users/password_reset'
  end

  post '/password_reset' do
    user = User.first(email: params[:email]) # find the record of the user that's recovering the password.
    user.password_token = generate_token
    user.save
    SendResetEmail.call(user)
    erb :'users/recovery_sent'
  end

  get '/users/password_reset/:password_token' do
    erb :'/users/recover'
  end

  post '/users/password_reset/:password_token' do
    user = User.first(password_token: params[:password_token])
    user.password = params[:new_password]
    user.password_token = nil
    user.save
    erb :'sessions/new'
  end

  helpers do

    def current_user
      @user ||= User.first(id: session[:user_id]) if session[:user_id]
    end

    def generate_token
      SecureRandom.hex
    end

  end

end
