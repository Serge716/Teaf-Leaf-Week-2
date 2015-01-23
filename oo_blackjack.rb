# Blackjack is a game that is played with 2 or More players.  For the purpose of this game
# it will be played with 2 players.  1 Player and 1 dealer.  
# The Game is played with a deck of 52 cards
# values: 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A and suites: Hearts, Diamonds, Spades, Clubs
# The dealer shuffle the cards and deal 1 card to player, 1 card to dealer, another card to player, and
#   another card to dealer.  Then the cards are compared.  
# The numerical values = card number, and (J, Q, K) = 10 and A = 1 or 11
# After the 2 Cards are dealt the player gets a chance to Hit or Stay
# If the player get a score 21 player wins automatically
# If the player go over score 21 its an automatic loss
# if the player score is less than 21 and choose to Stay
# the player score is compare to the dealers score if the dealer score is greater than player score
#   dealer wins
# if the player score is greater than the dealer score and dealer score is 17 or greater player wins
# if the player score is greater and dealer score is less than 17 the dealer will hit self until score is 
#   greater than player score or and 21 or less dealer wins
# if the dealer go over 21 dealer looses

class Card
  attr_accessor :suit, :face_value

  def initialize(suit, face_value)
    @suit = suit
    @face_value = face_value
  end

  def human_output
    "#{face_value} of #{change_suit_to_full_name}"
  end

  def to_s
    human_output
  end

  def change_suit_to_full_name
    return_suit = case suit
                    when "C" then "Clubs"
                    when "D" then "Diamonds"
                    when "H" then "Hearts"
                    when "S" then "Spades"
                  end
    return_suit
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ["C", "D", "H", "S"].each do |suit|
      [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    @cards.shuffle!
  end

  def deal_one
    @cards.pop
  end

  def size
    @cards.size
  end
end

module Hand
  def show_card
    puts puts "----- #{name} -----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> #{total}"
  end

  def total
    face_values = cards.map {|card| card.face_value }

    total = 0

    face_values.each do |value|
      if value == "A"
        total += 11
      else
        total += (value.to_i == 0 ? 10 : value.to_i)
      end
    end

    # Correct for Aces

    face_values.select {|value| value == "A"}.count.times do 
      break if total <= 21
      total -= 10
    end
    total
  end 

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > BlackJack::BLACKJACK_AMOUNT
  end
end

class Player
  include Hand
  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def show_flop
    show_card
  end
end

class Dealer
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def show_flop
    puts "---- Dealer's Hand ----"
    puts "==> First card is hidden"
    puts "Second card is #{cards[1]}"
  end
end

class BlackJack
  attr_accessor :cards, :player, :dealer, :deck

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MINIMUN = 17
  
  def initialize
    @player = Player.new("Serge")
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def set_player_name
    puts "What's your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry Dealer Hit BlackJack. #{player.name} loses"
      else
        puts "Congratulations you hit Blackjack. #{player.name} win."
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulations, dealer busted #{player.name} wins."
      else
        puts "Sorry, #{player.name} busted. #{player.name} loses."
      end
      play_again?
    end
  end

  def player_turn
    puts "#{player.name}'s turn."

    blackjack_or_bust?(player)
    while !player.is_busted?
      puts "What would you like to do 1) Hit or 2) Stay" 
      response = gets.chomp

      if !["1", "2"].include?(response)
        puts "Error: you must enter 1 or 2"
        next
      end
      if response == "2"
        puts "#{player.name} chose to stay"
        break
      end

      #hit
      new_card = deck.deal_one
      puts "Dealing card to #{player.name}: #{new_card}"
      player.add_card(new_card)
      puts "#{player.name}'s total is now: #{player.total}"

      blackjack_or_bust?(player)
    end
    puts "#{player.name} stays at #{player.total}"
  end

  def dealer_turn
    puts "Dealer's turn."

    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_MINIMUN
      new_card = deck.deal_one
      puts  "Dealing card to dealer #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer total is now: #{dealer.total}"

      blackjack_or_bust?(dealer)
    end

    puts "Dealer stays at #{dealer.total}."
  end

  def who_won?
    if player.total > dealer.total
      puts "Congratulations #{player.name} wins."
    elsif player.total < dealer.total
      puts "#{player.name} loses."
    else
      puts "It's a tie!"
    end
    play_again?
  end

  def play_again?
    puts ""
    puts "Would you like to play again? 1) yes, 2) no, exit"
    if gets.chomp == '1'
      puts "Staring a new game..."
      puts ""
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Goodbye!"
      exit
    end
  end

  def start
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

game = BlackJack.new
game.start
