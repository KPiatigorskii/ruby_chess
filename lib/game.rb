# frozen_string_literal: true

# contains logic for chess board
class Game
  # Declares error message when user enters invalid input
  class InputError < StandardError
    def message
      'Invalid input! Enter column & row, for example: d2'
    end
  end

  # Declares error message when user enters invalid move
  class CoordinatesError < StandardError
    def message
      'Invalid coordinates! Enter column & row of the correct color.'
    end
  end

  # Declares error message when user enters invalid move
  class MoveError < StandardError
    def message
      'Invalid coordinates! Enter a valid column & row to move.'
    end
  end

  # Declares error message when user enters invalid move
  class PieceError < StandardError
    def message
      'Invalid piece! This piece does not have any legal moves.'
    end
  end

  def initialize(board = Board.new)
    @board = board
    @current_turn = :white
  end

  # Public Script Method -> No tests needed (test inside methods)
  # Need to test any outgoing command messages ??
  def play
    game_mode
    @board.initial_placement
    @board.to_s
    16.times { player_turn }
  end

  # Script Method -> Test methods inside
  # Need to test any outgoing command messages ??
  def player_turn
    puts "#{@current_turn.capitalize}'s turn!"
    select_piece_coordinates
    @board.to_s
    move = select_move_coordinates
    @board.update(move)
    @board.to_s
    switch_color
  end

  # Script Method -> No tests needed (test inside methods)
  # Need to test any outgoing command messages ??
  def select_piece_coordinates
    input = user_input('What piece would you like to move?')
    validate_input(input)
    coords = translate_coordinates(input)
    validate_piece_coordinates(coords)
    @board.update_active_piece(coords)
    validate_active_piece
  rescue StandardError => e
    puts e.message
    retry
  end

  # Script Method -> No tests needed (test inside methods)
  # Need to test any outgoing command messages ??
  def select_move_coordinates
    puts en_passant_warning if @board.possible_en_passant?
    # puts king_check_warning if King is in check!
    input = user_input('Where would you like to move it?')
    validate_input(input)
    coords = translate_coordinates(input)
    validate_move(coords)
    coords
  rescue StandardError => e
    puts e.message
    retry
  end

  private

  def game_mode
    mode = user_input('Press [1] to play computer or [2] for 2-player')
    return mode if mode.match?(/^[12]$/)

    puts 'Input error! Enter 1 or 2'
    game mode
  end

  def switch_color
    @current_turn = @current_turn == :white ? :black : :white
  end

  # Tested (private, but used in a public script method)
  def validate_input(input)
    raise InputError unless input.match?(/^[a-h][1-8]$/)
  end

  # Tested (private, but used in a public script method)
  def validate_piece_coordinates(coords)
    raise CoordinatesError unless @board.valid_piece?(coords, @current_turn)
  end

  # Tested (private, but used in a public script method)
  def validate_move(coords)
    raise MoveError unless @board.valid_piece_movement?(coords)
  end

  # Tested (private, but used in a public script method)
  def validate_active_piece
    raise PieceError unless @board.active_piece_moveable?
  end

  # Tested (private, but used in a public script method)
  def translate_coordinates(input)
    translator ||= NotationTranslator.new
    translator.translate_notation(input)
  end

  def user_input(phrase)
    puts phrase
    gets.chomp
  end

  def en_passant_warning
    <<~HEREDOC
      To capture this pawn en passant, enter the \e[41mcapture coordinates\e[0m.
      \e[36mYour pawn will be moved to the square in front of it!\e[0m
    HEREDOC
  end
end
