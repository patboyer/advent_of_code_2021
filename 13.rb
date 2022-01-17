#!/usr/bin/ruby -w

points = File.readlines('input/13_input.txt')
             .collect { |line| line.strip }
						 .select  { |line| line.match(/,/) }
						 .collect { |line| line.split(/,/ ) }
						 .collect { |fields| fields.collect { |s| s.to_i } }

folds = File.readlines('input/13_input.txt')
            .collect { |line| line.strip }
						.select  { |line| line.match(/fold/) }
						.collect { |line| line.match(/([xy])=(\d+)$/).captures }

new_points = []

folds.each do |f|
	new_points = []
	dim, diff  = f
	diff       = diff.to_i

	points.each do |p|
		x, y = p

		if dim == 'x' and x > diff
			new_points << [ 2 * diff - x, y ]
		elsif dim == 'y' and y > diff
			new_points << [ x, 2 * diff - y ]
		else
			new_points << [ x, y ]
		end
	end

	new_points.uniq!
	points = new_points.clone
	puts "#{f[0]}=#{f[1]}: #{new_points.length} points" 
end

xmin = new_points.collect { |p| p[0] }.min
xmax = new_points.collect { |p| p[0] }.max
ymin = new_points.collect { |p| p[1] }.min
ymax = new_points.collect { |p| p[1] }.max

ymin.upto(ymax).each do |y|
	xmin.upto(xmax).each do |x|
		print (new_points.include?([x, y])) ? '#' : '.'
	end

	print "\n"
end
