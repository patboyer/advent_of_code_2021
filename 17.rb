#!/usr/bin/ruby -w

def guess(vx, vy, xmin, xmax, ymin, ymax)
  x, y   = [ 0, 0 ]
	height = 0

	loop do
	  x += vx 
		y += vy 
		
		if x > xmax or y < ymin 
		  return -1
		elsif x >= xmin and x <= xmax and y >= ymin and y <= ymax
		  return height 
		else 
		  height = [ y, height ].max
			vy -= 1
			vx -= 1 unless vx == 0
		end
	end
end

xmin, xmax, ymin, ymax = [ 230, 283, -107, -57 ]
height = 0
num_hits = 0

(1).upto(xmax).each do |vx|
  (ymin).upto(ymin.abs).each do |vy|
    result = guess(vx, vy, xmin, xmax, ymin, ymax)
		
		if result != -1
			num_hits += 1
		end

		if result > height
			height = result
		end
	end
end

puts "A: #{height}"
puts "B: #{num_hits}"
