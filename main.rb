require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

helpers do
  def total(player_hand)
    player_total = 0
    player_hand.each do |card|
      if card[1] == 'A'
        player_total += 11
      else player_total += card[1].to_i == 0 ? 10 : card[1].to_i
      end
    end
      if player_total > 21
        player_hand.each do |card|
          if card[1] == 'A'
            player_total -= 10
          end
        end
      end
    player_total
  end

  def card_image(card)
    suit = case card[0]
      when 'H' then 'hearts'
      when 'D' then 'diamonds'
      when 'C' then 'clubs'
      when 'S' then 'spades'
    end
    value = card[1]

    if ['J', 'Q', 'K', 'A'].include?(value)
      value = case card[1]
        when 'J' then 'jack'
        when 'Q' then 'queen'
        when 'K' then 'king'
        when 'A' then 'ace'
      end
    end

    "<img src='/images/cards/#{suit}_#{value}.jpg' class='card-image'>"
  end

  def win
    session[:bankroll] += session[:wager].to_i
    @new_game = true
  end

  def lose
    session[:bankroll] -= session[:wager].to_i
    @new_game = true
  end
end

before do
  @hit_or_stay_buttons = true
  @dealer_turn = false
  @new_game = false
end

get '/' do
  if !session[:username]
    erb :home
  else
    redirect '/wager'
  end
end

get '/start-over' do
  session[:username] = nil
  redirect '/'
end

post '/setup' do
  if params[:username].empty?
    @error = "Name is required"
    halt erb(:home)
  elsif params[:username].to_i != 0
    @error = "That's not your name..."
    halt erb(:home)
  end
  session[:username] = params[:username]
  session[:bankroll] = 500
  redirect '/wager'
end

get '/wager' do
  if session[:bankroll] == 0
    redirect '/no-bankroll'
  else
    suits = ['H', 'D', 'S', 'C']
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
    erb :wager
  end
end

post '/wager' do
  session[:wager] = params[:wager]
  if session[:wager].to_i > session[:bankroll].to_i
    @error = "You cannot bet more than your bankroll"
    session[:wager] = 0
    halt erb(:wager)
  elsif session[:wager].to_i == 0
    @error = "Please use a real number"
    session[:wager] = 0
    halt erb(:wager)
  end
  player_hand = []
  dealer_hand = []
  deck = session[:deck]
  player_hand << deck.pop
  dealer_hand << deck.pop
  player_hand << deck.pop
  dealer_hand << deck.pop
  session[:player_hand] = player_hand
  session[:dealer_hand] = dealer_hand
  session[:deck] = deck
  redirect '/game'
end

get '/game' do
  erb :game
end



post '/game/hit' do
  session[:player_hand] << session[:deck].pop
  if total(session[:player_hand]) > 21
    @error = "Sorry, #{session[:username]}'s total is greater than 21 - bust!"
    @hit_or_stay_buttons = false
    lose
  elsif total(session[:player_hand]) == 21
    @success = "Congratulations, #{session[:username]} hit blackjack!"
    @hit_or_stay_buttons = false
    win
  end
  erb :game, layout: false
end

post '/game/stay' do
  @success = "#{session[:username]} has chosen to stay"
  @hit_or_stay_buttons = false
  @dealer_turn = true
  erb :game
end

post '/game/dealer/turn' do
  @dealer_turn = true
  if total(session[:dealer_hand]) > 21
    @dealer_turn = false
    @sucess = "Dealer busts, #{session[:username]} wins!"
    win
  elsif total(session[:dealer_hand]) == 21
    @dealer_turn = false
    @error = "Dealer hit blackjack, #{session[:username]} loses!"
    lose
  elsif total(session[:dealer_hand]) < 17
    session[:dealer_hand] << session[:deck].pop
  else
    @dealer_turn = false
    redirect '/compare-scores'
  end
  erb :game
end

get '/compare-scores' do
  @hit_or_stay_buttons = false
  if total(session[:dealer_hand]) > 21
    @success = "Dealer busts, #{session[:username]} wins!"
    win
  elsif total(session[:dealer_hand]) == 21
    @error = "Dealer hit blackjack, #{session[:username]} loses!"
    lose
  elsif total(session[:dealer_hand]) > total(session[:player_hand])
    @error = "Dealer score of #{total(session[:dealer_hand])} beats #{session[:username]}'s score of #{total(session[:player_hand])}."
    lose
  elsif total(session[:dealer_hand]) < total(session[:player_hand])
    @success = "#{session[:username]}'s score of #{total(session[:player_hand])} beats dealer's score of #{total(session[:dealer_hand])}."
    win
  else
    @error = "It's a tie!"
    @new_game = true
  end
  erb :game
end

get '/no-bankroll' do
  erb :no_bankroll
end
