#!/usr/bin/ruby -w

class Octopi 
	attr_accessor :flashes

	def initialize(lines)
		@grid = lines.collect { |line| line.strip }
		             .collect { |line| line.split(//).collect { |s| s.to_i } }
		
		@flashes    = 0
		@height     = 10
		@width      = 10
		@max_energy = 10
		@visited    = []
	end

	def all_flashing?
		@grid.flatten.count(0) == @height * @width
	end

	def step 
		flashing = []
		@visited = []

		# increase energy of each octopus by 1
    0.upto(@height-1).each do |y|
			0.upto(@width-1).each do |x|
				@grid[y][x] += 1
				flashing << [x, y] if @grid[y][x] >= @max_energy
			end
		end

		# octopi flash
		flashing.each { |arr| _step(arr[0], arr[1]) }

		# set energy to zero for any octopus that flashed
    0.upto(@height-1).each do |y|
			0.upto(@width-1).each do |x|
				@grid[y][x] = 0 if @grid[y][x] >= @max_energy
			end
		end
	end

	private
	def _step(x, y)
		if @visited.include?([x,y])
			return
		elsif x < 0 or x >= @width 
			return 
		elsif y < 0 or y >= @height 
			return
		else 
			@grid[y][x] += 1

			if @grid[y][x] >= @max_energy 
				@flashes += 1
				@visited << [x, y]
				_step(x-1, y-1)
				_step(x-1, y)
				_step(x-1, y+1)
				_step(x, y-1)
				_step(x, y+1)
				_step(x+1, y-1)
				_step(x+1, y)
				_step(x+1, y+1)
			end
		end
	end
end

input = File.readlines('input/11_input.txt')

octopi = Octopi.new(input)
100.times { octopi.step }

puts "A: #{octopi.flashes}"

octopi = Octopi.new(input)
resultB = 0

while not octopi.all_flashing?
	octopi.step 
	resultB += 1
end

puts "B: #{resultB}"
