#!/usr/bin/ruby -w

class Point
	attr_accessor :x, :y 

	def initialize(x, y)
		@x = x
		@y = y
	end

	def to_s 
		"(#{@x}, #{@y})"
	end

	def ==(other)
		@x == other.x and @y == other.y
	end
end

class Line
	attr_accessor :p1, :p2, :points

	def initialize(x1, y1, x2, y2)
		@p1 = Point.new(x1, y1)
		@p2 = Point.new(x2, y2)
		@points = _points
	end

	def intersect(line2)
		@points.select { |p| line2.points.include?(p) }
	end

	def is_horizontal?
		@p1.y == @p2.y
	end

	def is_vertical?
		@p1.x == @p2.x
	end

	def to_s
		"#{@p1} -> #{@p2}: " + @points.collect {|p| "#{p}" }.join(', ')
	end

	private
	def _points 
		xmin = [@p1.x, @p2.x].min
		xmax = [@p1.x, @p2.x].max
		ymin = [@p1.y, @p2.y].min
		ymax = [@p1.y, @p2.y].max

		if is_horizontal?
			xmin.upto(xmax).to_a.collect { |x| Point.new(x, @p1.y).to_s }
		elsif is_vertical?
			ymin.upto(ymax).to_a.collect { |y| Point.new(@p1.x, y).to_s }
		elsif (@p1.x < @p2.x and @p1.y > @p2.y)
			n = 0; ymax.downto(ymin).to_a.collect { |y| p = Point.new(xmin+n, y); n += 1; p.to_s }
		elsif (@p1.x > @p2.x and @p1.y < @p2.y)
			n = 0; ymax.downto(ymin).to_a.collect { |y| p = Point.new(xmin+n, y); n += 1; p.to_s }
		else
			n = 0; ymin.upto(ymax).to_a.collect { |y| p = Point.new(xmin+n, y); n += 1; p.to_s }
		end
	end
end

input = File.readlines('input/05_input.txt').collect { |s| s.strip }

intersectionsA = Hash.new(0)
intersectionsB = Hash.new(0)

input.collect { |s| s.match(/(\d+),(\d+) -> (\d+),(\d+)/) }
		 .collect { |arr| Line.new(arr[1].to_i, arr[2].to_i, arr[3].to_i, arr[4].to_i) }
     .each do |line|
       line.points.each do |p|
	       intersectionsA[p] += 1 if (line.is_horizontal? or line.is_vertical?)
	       intersectionsB[p] += 1
			 end
	   end

puts "A: #{intersectionsA.select {|k,v| v > 1}.keys.count }"
puts "B: #{intersectionsB.select {|k,v| v > 1}.keys.count }"