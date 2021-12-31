#!/usr/bin/ruby -w

class Point
  attr_accessor :x, :y, :val

	def initialize(x, y, val)
	  @x   = x
		@y   = y
		@val = val
	end
end

class Grid 
	attr_accessor :basins 

	def initialize(lines)
		@grid = lines.collect { |line| line.strip }
								 .collect { |line| line.split(//).collect { |s| s.to_i } }

		@basins  = []
		@height  = @grid.length
		@points  = []
		@visited = []
		@width   = @grid[0].length

		find_lowpoints
	end

	def find_basin_size(p)
		@visited = []
		@basins << _find_basin_size(p.x, p.y, p.val)
	end

	def find_lowpoints
	  last_line = @height - 1
		max_idx   = @width - 1

		0.upto(last_line).each do |y|
		  0.upto(max_idx).each do |x|
			  val = @grid[y][x]

			  neighbors = [
					(x > 0)         ? @grid[y][x - 1] : 10,
					(x < max_idx)   ? @grid[y][x + 1] : 10,
					(y > 0)         ? @grid[y - 1][x] : 10,
					(y < last_line) ? @grid[y + 1][x] : 10,
				]

				if val < neighbors.min 
				  p = Point.new(x, y, val)
					@points << p
					find_basin_size(p)
				end
			end
		end
	end

	def risk
		@points.collect { |p| 1 + p.val }.sum
	end

	private
	def _find_basin_size(x, y, last)
		if x < 0 or x == @width
			return 0
		elsif y < 0 or y == @height 
			return 0 
		elsif @visited.include?("#{x},#{y}")
			return 0
		end

		val = @grid[y][x]

		if val == 9
			return 0
		elsif val < last 
			return 0
		else 
			@visited << "#{x},#{y}"
			return 1 + _find_basin_size(x-1, y,   val) + 
			           _find_basin_size(x+1, y,   val) + 
								 _find_basin_size(x,   y-1, val) + 
								 _find_basin_size(x,   y+1, val)
		end
	end
end

input = File.readlines('input/09_input.txt')

grid = Grid.new(input)
puts "A: #{grid.risk}"
puts "B: #{grid.basins.sort.reverse.slice(0, 3).inject(1) { |b, result| result * b } }"
