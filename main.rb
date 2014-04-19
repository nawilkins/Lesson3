require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

get '/' do
  if !session[:username]
    erb :home
  else
    redirect '/wager'
  end
end

post '/setup' do
  session[:username] = params[:username]
  redirect '/wager'
end

get '/wager' do
  suits = ['Hearts', 'Diamonds', 'Spades', 'Clubs']
  values = ['2', '3', '4', '5', '6', '7', '8', '9', 'J', 'Q', 'K', 'A']
  deck = []
  suits.each do |suit|
    values.each do |value|
      deck << [suit, value]
    end
  end
  deck.shuffle!
  session[:deck] = deck
  session[:player_hand] = []
  session[:dealer_hand] = []
  session[:bankroll] = 500
  erb :wager
end

post '/wager' do
  session[:wager] = params[:wager]
  session[:player_hand] = session[:deck].pop
  session[:dealer_hand] = session[:deck].pop
  session[:player_hand] = session[:deck].pop
  session[:dealer_hand] = session[:deck].pop
  redirect '/game'
end

get '/game' do
  erb :game
end
