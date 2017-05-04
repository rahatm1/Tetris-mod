# Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.
#
require_relative './hw6provided'

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
	def initialize(point_array, board)
		super(point_array, board)
	end

	All_Pieces.push(rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 1]]))
	All_Pieces.push(
			   [[[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]],
			   [[0, 0], [0, -1], [0,-2], [0, 1], [0, 2]]])
	All_Pieces.push(rotations([[0, 0],[0, 1], [1, 1]]))

	def self.next_piece (board)
		MyPiece.new(All_Pieces.sample, board)
	end

	def self.cheat_piece (board)
		MyPiece.new([[0,0]], board)
	end

end

class MyBoard < Board
	def initialize(game)
		super(game)
		@current_block = MyPiece.next_piece(self)
		@cheat = false
	end

	def rotate_full
		if !game_over? and @game.is_running?
		  @current_block.move(0, 0, -2)
		end
		draw
	end

	def next_piece
		if (@cheat)
			@current_block = MyPiece.cheat_piece(self)
			@cheat = false
		else
			@current_block = MyPiece.next_piece(self)
		end
		@current_pos = nil
	end

	def store_current
		locations = @current_block.current_rotation
		displacement = @current_block.position
		len = @current_block.current_rotation.length
		(0..len-1).each{|index| 
		  current = locations[index];
		  @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
		  @current_pos[index]
		}
		remove_filled
		@delay = [@delay - 2, 80].max
	end

	def do_cheat
		if (!@cheat and @score >= 100)
			@cheat = true
			@score -= 100
		end
	end

end

class MyTetris < Tetris
	def initialize()
		super()
	end

	def key_bindings
		super()
		@root.bind('u', proc {@board.rotate_full})
		@root.bind('c', proc {@board.do_cheat})
	end

	def set_board
		@canvas = TetrisCanvas.new
		@board = MyBoard.new(self)
		@canvas.place(@board.block_size * @board.num_rows + 3,
					  @board.block_size * @board.num_columns + 6, 24, 80)
		@board.draw
	end

end
