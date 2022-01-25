#!/usr/bin/ruby -w

def enhance(img, algorithm, n)
	border = ((algorithm[0] == '#') and (n % 2 == 1)) ? '1' : '0'
	img = img.collect { |row| row.gsub('#', '1').gsub('.', '0') }
  xmin, xmax = [ 0, img[0].length - 1 ]
  ymin, ymax = [ 0, img.length - 1 ]

	(ymin-2).upto(ymax+2).collect do |y|
	  (xmin-2).upto(xmax+2).collect do |x|
		  arr = [
				((y-1 >= ymin) and (y-1 <= ymax) and (x-1 >= xmin) and (x-1 <= xmax)) ? img[y-1][x-1] : border,
				((y-1 >= ymin) and (y-1 <= ymax) and (x   >= xmin) and (x   <= xmax)) ? img[y-1][x]   : border,
				((y-1 >= ymin) and (y-1 <= ymax) and (x+1 >= xmin) and (x+1 <= xmax)) ? img[y-1][x+1] : border,
				((y   >= ymin) and (y   <= ymax) and (x-1 >= xmin) and (x-1 <= xmax)) ? img[y][x-1]   : border,
				((y   >= ymin) and (y   <= ymax) and (x   >= xmin) and (x   <= xmax)) ? img[y][x]     : border,
				((y   >= ymin) and (y   <= ymax) and (x+1 >= xmin) and (x+1 <= xmax)) ? img[y][x+1]   : border,
				((y+1 >= ymin) and (y+1 <= ymax) and (x-1 >= xmin) and (x-1 <= xmax)) ? img[y+1][x-1] : border,
				((y+1 >= ymin) and (y+1 <= ymax) and (x   >= xmin) and (x   <= xmax)) ? img[y+1][x]   : border,
				((y+1 >= ymin) and (y+1 <= ymax) and (x+1 >= xmin) and (x+1 <= xmax)) ? img[y+1][x+1] : border,
			].join('')

			algorithm[ arr.to_i(2) ]
		end.join('')
	end
end

input     = File.readlines('input/20_input.txt').collect { |line| line.strip }
algorithm = input[0]
img       = input.slice(2, input.length)

2.times { |n| img = enhance(img, algorithm, n) }
num_pixels = img.collect { |row| row.split(//).select { |c| c == '#' }.count }.sum
puts "A: #{num_pixels}"

48.times { |n| img = enhance(img, algorithm, n) }
num_pixels = img.collect { |row| row.split(//).select { |c| c == '#' }.count }.sum
puts "B: #{num_pixels}"