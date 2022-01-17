#!/usr/bin/ruby -w

def find_safest_path(cave)
	height  = cave.length 
	width   = cave[0].length
	max     = width * height * 10
	dist    = Hash.new(max)
	nodes   = Hash.new(false)
	visited = Hash.new(false)

	dist[[0,0]]  = 0
	nodes[[0,0]] = true

	while nodes.any?
		u = nodes.sort_by { |k,v| v }.first[0]
		nodes.delete(u)

		x, y = u
		neighbors = [ [x-1, y], [x+1, y], [x, y-1], [x, y+1] ]
		  .select  { |x, y| x >= 0 and x < width and y >= 0 and y < height}

		neighbors.each do |v|
			x2, y2   = v
			dist[v]  = [ dist[v], dist[u] + cave[y2][x2] ].min
			nodes[v] = true unless visited[v] 
		end

		visited[u] = true
	end

	return dist[[height-1, width-1]]
end

def init_cave(steps = 0)
	lines = File.readlines('input/15_input.txt')
              .collect { |line| line.strip }
			        .collect { |line| line.split(//).collect { |s| s.to_i } }
	
	if steps > 0
		height = lines.length
		width  = lines[0].length
		cave   = Array.new(height*steps) { Array.new(width*steps, height*width*9) }

		0.upto(steps - 1).each do |ystep|
			0.upto(steps - 1).each do |xstep|
				0.upto(height - 1).each do |y|
					y2 = y + (ystep * height)

					0.upto(width - 1).each do |x|
						x2    = x + (xstep * width)
						val   = lines[y][x] + xstep + ystep
						val  -= 9 if val > 9
						cave[y2][x2] = val
					end
				end
			end
		end

		return cave
	else
		return lines
	end
end

puts "A: #{find_safest_path(init_cave)}"
puts "B: #{find_safest_path(init_cave(5))}"  # 2842
