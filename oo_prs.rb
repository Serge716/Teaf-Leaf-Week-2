# 2 player player rps.  Both players pic a hand of rock, paper, or scissors.  Then the hands are
# compared if player1 and player2 hands are the same it a tie, paper > rock, rock > scissors
# scissors > paper

class Hand
  include Comparable

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def <=>(another_hand)
    if @value ==another_hand.value
      0
    elsif (@value == 'p' && another_hand.value == 'r') || (@value == 'r' && another_hand.value == 's') ||
            (@value == 's' && another_hand.value == 'p')
      1
    else
      -1
    end
  end

  def display_winning_message
    case @value
    when 'p'
      puts "Paper wraps Rock"
    when 'r'
      puts "Rock Smashes Scissors"
    when 's'
      puts "Scissors cuts Paper"
    end
  end
end

class Player
  attr_accessor :hand
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "#{name} currently has a hand of #{self.hand.value}"
  end
end

class Human < Player
  def pick_hand
    begin
      puts "Pick one (P/R/S):"
      player_choice = gets.chomp.downcase
    end until Game::CHOICES.keys.include?(player_choice)

    self.hand = Hand.new(player_choice)

  end
end

class Computer < Player
  def pick_hand
    self.hand = Hand.new(Game::CHOICES.keys.sample)
  end
end

class Game

  CHOICES = { 'p' => 'paper', 'r' => 'Rock', 's' => 'Scissors'}

  attr_reader :player, :computer
  def initialize
    @player = Human.new("Bob")
    @computer = Computer.new("The Machine")
  end

  def compare_hands
    if player.hand == computer.hand
      puts "Its a tie"
    elsif player.hand > computer.hand
      player.hand.display_winning_message
      puts "#{player.name} Won!"
    else
      puts "#{computer.name} Won!"
    end      
  end

  def play
    begin
      player.pick_hand
      computer.pick_hand
      compare_hands
      puts "(Press Any Key To Play Again) (Press 'N' to Quit)"
      answer = gets.chomp.downcase
    end until answer == 'n'
  end
end

game = Game.new.play



# class Hand
# end

# class Player
#   attr_accessor :choice
#   attr_reader :name
  
#   def initialize(name)
#     @name = name
#   end

#   def to_s
#     "#{name} currently have a choice of #{choice}"
#   end
# end

# class Human < Player
#   def pick_hand
#     begin
#       puts "Pick one (P/R/S):"
#       player_choice = gets.chomp.downcase
#     end until Game::CHOICES.keys.include?(player_choice)

#     self.choice = player_choice

#   end
# end

# class Computer < Player
#   def pick_hand
#     self.choice = Game::CHOICES.keys.sample
#   end
# end

# class Game
#   CHOICES = { 'p' => 'paper', 'r' => 'Rock', 's' => 'Scissors'}

#   attr_reader :player, :computer

#   def initialize
#     @player = Human.new("John")
#     @computer = Computer.new("Computer")
#   end

#   def play
#     player.pick_hand
#     computer.pick_hand
#     puts player
#     puts computer
#   end
# end

# game = Game.new.play