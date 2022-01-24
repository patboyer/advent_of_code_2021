#!/usr/bin/ruby -w

class Node 
	attr_accessor :pos, :val

	def initialize(val)
		if val.class == Array
			@val = val.collect { |v| Node.new(v) }
		else
			@val = val.to_i
		end

		@pos = nil
	end

	def to_a 
		@val.class == Array ? @val.collect { |n| n.to_a } : @val
	end

	def to_s 
		@val.class == Array ? @val.collect { |n| n.to_s } : "#{@val} (#{@pos})"
	end
end

class SnailfishNumber
	def initialize(val)
		@root = Node.new(val)
		order(@root, 1)
		reduce
	end

	def add(other)
		SnailfishNumber.new([ @root.to_a, other.to_a ])
	end

	def find(node, target_pos)
		if node.val.class == Array
			left, right = node.val
			return find(left, target_pos) || find(right, target_pos)
		else
			return node.pos == target_pos ? node : nil
		end
	end

	def order(node, pos)
		if node.val.class == Array 
			node.val.each { |v| pos = order(v, pos) }
			return pos
		else 
			node.pos = pos 
			return pos + 1
		end
	end 

	def to_a
		@root.to_a
	end

	def to_s 
		@root.to_s
	end

	def explode(node, depth)
		if @exploded
			return
		elsif depth == 5 and node.val.class == Array
		  @exploded = true
		  left, right = node.val
			new_left = find(@root, left.pos - 1)
			new_left.val += left.val if new_left
			new_right = find(@root, right.pos + 1)
			new_right.val += right.val if new_right

			node.val = 0 
		elsif node.val.class == Array 
		  node.val.each { |n| explode(n, depth + 1) }
		else 
		  nil
		end
	end

	def magnitude(node=@root)
		if node.val.class == Array
			left, right = node.val
			3*magnitude(left) + 2*magnitude(right)
		else	
			node.val
		end
	end

	def reduce 
		loop do
		  @exploded = false 
			@split    = false

			explode(@root, 1)
			order(@root, 1)

			unless @exploded
				split(@root)
				order(@root, 1)
			end

			break unless @exploded or @split
		end

		order(@root, 1)
	end

	def split(node)
		if @split
			return
		elsif node.val.class == Array
			left, right = node.val 
			split(left)
			split(right)
		elsif node.val > 9
			@split = true
			node.val = [
				Node.new((node.val.to_f / 2).floor),
				Node.new((node.val.to_f / 2).ceil),
			]
		end
	end
end

input = File.readlines('input/18_input.txt').collect { |line| eval(line.strip) }
result = SnailfishNumber.new(input.shift)
result = input.inject(result) { |sum, n| sum.add(n) }.magnitude
puts "A: #{result}"

max = 0
(0).upto(input.length - 1).each do |i|
	(0).upto(input.length - 1).each do |j|
		if i != j
			mag = SnailfishNumber.new(input[i])
			                     .add(input[j])
													 .magnitude

			puts "#{i}, #{j}: #{mag}"
			max = (mag > max) ? mag : max
		end
	end
end

puts "B: #{max}"
