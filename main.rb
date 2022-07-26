# CLASSES
class Mastermind
  def initialize
    @colors = %w[red white orange green blue yellow]
    @secret_code = []
  end

  def rules
    text1_rules
    colors_to_text
    text2_rules
  end

  def colors_text_game
    puts "\nThese are the colors that you can choose:"
    colors_to_text
  end

  def colors_to_text
    @colors.each do |color|
      print color.to_s
      case color
      when @colors[-2] then print ' or '
      when @colors.last then print ".\n"
      else print ', '
      end
    end
  end

  def color
    puts "\nEnter the #{@i}° color:"
    @color = gets.chomp.strip.downcase
    until @colors.include?(@color)
      print "\nOOPS! Seems \"#{@color}\" is not a valid color. Try again."
      colors_text_game
      puts "\nEnter the #{@i}° color:"
      @color = gets.chomp.strip.downcase
    end
  end

  def check_and_show_guesses
    generate_variables
    check_correct_guess
    check_correct_guess_in_order
    show_num_of_correct_guesses
    show_num_of_correct_guesses_in_order
  end

  def generate_variables
    @temp_secret_code = []
    @secret_code.each { |color| @temp_secret_code << color }
    @correct_guesses = []
    @correct_guesses_in_order = []
  end

  def check_correct_guess
    4.times do |i|
      @correct_guesses << @temp_secret_code.any?(@code[i])
      next unless @temp_secret_code.any?(@code[i])

      @temp_secret_code.delete_at(@temp_secret_code.find_index(@code[i]).to_i)
    end
  end

  def check_correct_guess_in_order
    4.times do |i|
      @correct_guesses_in_order << (@secret_code[i] == @code[i])
    end
  end

  def show_num_of_correct_guesses
    case @correct_guesses.count(true)
    when 0 then puts "\nYou have not guessed any colors correctly. But don\'t give up: try again!"
    else puts "\nYou guessed #{@correct_guesses.count(true)} colors correctly!"
    end
  end

  def show_num_of_correct_guesses_in_order
    return unless @correct_guesses.count(true).positive?

    case @correct_guesses_in_order.count(true)
    when 0 then puts "You have not guessed any colors, in order, correctly. But don\'t give up: try again!"
    else puts "You guessed #{@correct_guesses_in_order.count(true)} colors, in order, correctly!"
    end
  end

  def winner?
    true if @correct_guesses_in_order.count(true) == 4
  end
end

class Creator < Mastermind
  def initialize
    super
    generate_possible_codes
    generate_code
    game
  end

  def generate_possible_codes
    @possible_codes = []
    until @possible_codes.length == 1296
      random_code = Array.new(4) { @colors.sample }
      @possible_codes << random_code unless @possible_codes.include?(random_code)
    end
  end

  def generate_code
    @i = 1
    colors_text_game
    4.times do
      color
      @secret_code << @color
      @i += 1
    end
  end

  def game
    12.times do |turn|
      turn_txt(turn)
      @code = %w[red red white white] if turn.zero?
      round
      if winner?
        puts "\nThe computer guessed the secret code! You lose."
        break
      elsif turn == 11
        lose_txt
        break
      end
      guess
      another_turn_txt
    end
  end

  def turn_txt(turn)
    puts "\nTurn #{turn + 1}!"
    puts "\nThis is your secret code: #{@secret_code}"
  end

  def round
    puts "\nThis is the guess of the computer: #{@code}"
    check_and_show_guesses
  end

  def show_num_of_correct_guesses
    case @correct_guesses.count(true)
    when 0 then puts "\nThe computer have not guessed any colors correctly."
    else puts "\nThe computer guessed #{@correct_guesses.count(true)} colors correctly!"
    end
  end

  def show_num_of_correct_guesses_in_order
    return unless @correct_guesses.count(true).positive?

    case @correct_guesses_in_order.count(true)
    when 0 then puts 'The computer have not guessed any colors, in order, correctly.'
    else puts "The computer guessed #{@correct_guesses_in_order.count(true)} colors, in order, correctly!"
    end
  end

  def guess
    invalid_codes = []
    @possible_codes.each do |code|
      @actual_possible_code = code
      generate_fake_variables
      code.each { |color| @temp_fake_secret_code << color }
      check_fake_guesses
      invalid_codes << code unless fake_and_true_guesses_same && fake_and_true_guesses_in_order_same
      fake_and_true_guesses_same && fake_and_true_guesses_in_order_same
    end
    invalid_codes.each { |code| @possible_codes.delete(code) }
    @code = @possible_codes.first
  end

  def check_fake_guesses
    check_fake_correct_guess
    check_fake_correct_guess_in_order
  end

  def generate_fake_variables
    @temp_fake_secret_code = []
    @fake_correct_guesses = []
    @fake_correct_guesses_in_order = []
  end

  def check_fake_correct_guess
    4.times do |i|
      @fake_correct_guesses << @temp_fake_secret_code.any?(@code[i])
      next unless @temp_fake_secret_code.any?(@code[i])

      @temp_fake_secret_code.delete_at(@temp_fake_secret_code.find_index(@code[i]).to_i)
    end
  end

  def check_fake_correct_guess_in_order
    4.times do |i|
      @fake_correct_guesses_in_order << (@code[i] == @actual_possible_code[i])
    end
  end

  def fake_and_true_guesses_same
    true if @correct_guesses.count(true) == @fake_correct_guesses.count(true)
  end

  def fake_and_true_guesses_in_order_same
    true if @correct_guesses_in_order.count(true) == @fake_correct_guesses_in_order.count(true)
  end

  def lose_txt
    puts "\nThis was the last round and the computer couldn't figure out the correct password. I guess you win!!\n"
  end
end

class Guesser < Mastermind
  def initialize
    super
    4.times { @secret_code << @colors.sample }
    game
  end

  def game
    12.times do |turn|
      puts "\nTurn #{turn + 1}!"
      play
      if winner?
        puts "\nCongratulations!!! You guessed the secret code! You got all the colors, in the correct order, right!"
        break
      elsif turn == 11
        lose_txt
      end
    end
  end

  def play
    guess
    check_and_show_guesses
  end

  def guess
    @i = 1
    @code = []
    colors_text_game
    4.times do
      color
      @code << @color
      @i += 1
    end
    puts "\nThis is your guess: #{@code}"
  end

  def lose_txt
    puts "\nUnfortunately this was the last round and you couldn't figure out the correct password. You lost.\n"
    puts "This was the secret code: #{@secret_code}"
  end
end

# METHODS
def show_rules?
  answer = gets.chomp.downcase
  until %w[yes no].include?(answer)
    puts "\n\"#{answer}\" is not a valid answer. "
    puts "\nDo you want to see a quick tutorial of how mastermind works?"
    puts "\n>Enter 'yes' if you do or 'no' if you don't."
    answer = gets.chomp.downcase
  end
  true if answer == 'yes'
end

def text1_rules
  puts "\nThe game is pretty simple:"
  puts "\nYour objective is to discover the secret code, which consists of a series of four colors,"
  puts 'and each one can be either:'
end

def text2_rules
  puts 'PS: colors can repeat many times.'
  puts "\nAnd you can choose whether you want to be the creator of the secret code or the guesser."
  puts "\nPretty simple, right?"
  puts "\nSo... shall we begin?"
  puts "\n>Press ENTER to continue<"
  gets.chomp
end

def another_turn_txt
  puts "\n>Press ENTER to go to another turn<"
  gets.chomp
end

puts 'Welcome to my implementation of Mastermind game!'
puts "\nDo you want to see a quick tutorial of how mastermind works?"
puts "\n>Enter 'yes' if you do or 'no' if you don't."

Mastermind.new.rules if show_rules?

puts "\nSo, do you want to be the creator or the guesser?"
answer = gets.chomp.strip.downcase
until %w[creator guesser].include?(answer)
  puts "\nOOPS! Seems #{answer} is not a valid answer."
  puts "\nEnter 'creator' or 'guesser'."
  answer = gets.chomp.strip.downcase
end

case answer
when 'creator' then Creator.new
else Guesser.new
end
