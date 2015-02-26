class Board 
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

  def initialize
    @space = {}
    (1..9).each{|position| @space[position] = Square.new('')}
  end

  def unmarked_squares
    @space.select{|_,square| square.empty}.values
  end

  def untaken_positions 
    @space.select{|_,square| square.empty}.keys
  end

  def all_squares_marked?
    unmarked_squares.size == 0
  end

  def mark_square(position, marker)
    @space[position].mark(marker)
  end

  def three_squares_in_a_row?(marker)
    WINNING_LINES.each do |line|
      return true if @space[line[0]].value == marker && @space[line[1]].value == marker && @space[line[2]].value == marker
    end
    false
  end

  def draw
    system 'clear'
    puts
    puts "     |     |"
    puts "  #{@space[1]}  |  #{@space[2]}  |  #{@space[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@space[4]}  |  #{@space[5]}  |  #{@space[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@space[7]}  |  #{@space[8]}  |  #{@space[9]}"
    puts "     |     |"
    puts
  end
end

class Square
  attr_reader :value
  def initialize(v)
    @value = v 
  end

  def empty
    @value == ''
  end

  def mark(marker)
    @value = marker
  end

  def to_s
    @value
  end
end

class Player 
  attr_reader :marker, :name
  def initialize(name, marker)
    @name = name
    @marker = marker 
  end
end

class Tictactoe
  def initialize 
    @board = Board.new
    @human = Player.new('You', 'X')
    @computer = Player.new('Computer', 'O')
    @current_player = @human
  end

  def current_player_marks_square 
    if @current_player == @human
      begin 
        puts "Please choose a square (1-9)."
        position = gets.chomp.to_i
      end until @board.untaken_positions.include?(position)
    else 
      position = @board.untaken_positions.sample
    end
    @board.mark_square(position, @current_player.marker)
  end

  def alternate_players
    if @current_player == @human
      @current_player = @computer
    else 
      @current_player = @human
    end
  end

  def current_player_wins?
    @board.three_squares_in_a_row?(@current_player.marker) 
  end

  def play
    @board.draw
    loop do  
      current_player_marks_square
      @board.draw
      if current_player_wins?
        puts "The winner is #{@current_player.name}"
        break
      elsif @board.all_squares_marked? 
        puts "It's a tie."
        break
      else
        alternate_players
      end
    end
  end
end

Tictactoe.new.play
