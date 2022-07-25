module MastermindText
  def welcome_text
    puts 'Welcome to my implementation of Mastermind game!'
  end

  def text1_rules
    puts "\nThe game is pretty simple:"
    puts "\nThe computer will get a random set of four colors - wich we call it \"secret code\" -,"
    puts 'and each one can be either:'
  end

  def text2_rules
    puts 'And all you need is to guess the secret code, in the correct order.'
    puts 'Pretty simple, right?'
    puts "\nOh, and the colors can repeat. More than once, in fact."
    puts "But don't worry: we will help you by telling you how correct your guess is."
    puts "\nSo... shall we begin?"
    puts "\n>Press ENTER to continue.<"
    gets.chomp
  end

  def text_show_rules
    puts "\nDo you want to see a quick tutorial?"
    puts "\n>Enter 'yes' if you do or 'no' if you don't."
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

  def text_last_round
    puts "\nUnfortunately this was the last round and you couldn't figure out the correct password. You lost.\n"
  end
end

class Mastermind
  include MastermindText
  def initialize
    @colors = %w[red white orange green blue yellow]
    @secret_code = []
    4.times { @secret_code << @colors.sample }
    p @secret_code
    welcome_text # from module
    rules if show_rules?
    game
  end

  def show_rules?
    text_show_rules # from module
    answer = gets.chomp.downcase
    until %w[yes no].include?(answer)
      puts "\n\"#{answer}\" is not a valid answer. "
      text_show_rules
      answer = gets.chomp.downcase
    end
    true if answer == 'yes'
  end

  def rules
    text1_rules # from module
    colors_to_text
    text2_rules # from module
  end

  def game
    12.times do |turn|
      puts "\nTurn #{turn + 1}!"
      generate_user_code
      check_and_show_guesses
      if check_winner
        puts "\nCongratulations!!! You guessed the secret code! You got all the colors, in the correct order, right!\n"
        break
      end
      text_last_round if turn == 11
    end
  end

  def generate_user_code
    @i = 1
    @user_code = []
    colors_text_game # from module
    4.times do
      user_color
      @user_code << @user_color
      @i += 1
    end
    puts "\nThis was your guess: #{@user_code}"
  end

  def user_color
    puts "\nEnter your guess for the #{@i}° color:"
    @user_color = gets.chomp.strip.downcase
    until @colors.include?(@user_color)
      print "\nOOPS! Seems \"#{@user_color}\" is not a valid color."
      colors_text_game # from module
      puts "\nEnter your guess for the #{@i}° color:"
      @user_color = gets.chomp.strip.downcase
    end
  end

  def check_and_show_guesses
    check_correct_guess
    check_correct_guess_in_order
    show_num_of_correct_guesses
    show_num_of_correct_guesses_in_order
  end

  def check_correct_guess
    i = 0
    generate_variables
    @secret_code.each { |color| @temp_secret_code << color }
    while i < @secret_code.length
      @correct_guesses << @temp_secret_code.any?(@user_code[i])
      if @temp_secret_code.any?(@user_code[i])
        @temp_secret_code.delete_at(@temp_secret_code.find_index(@user_code[i]).to_i)
      end
      i += 1
    end
  end

  def generate_variables
    @temp_secret_code = []
    @correct_guesses = []
    @correct_guesses_in_order = []
  end

  def check_correct_guess_in_order
    i = 0
    while i < @secret_code.length
      @correct_guesses_in_order << (@secret_code[i] == @user_code[i])
      i += 1
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

  def check_winner
    true if @correct_guesses_in_order.count(true) == 4
  end
end

Mastermind.new
