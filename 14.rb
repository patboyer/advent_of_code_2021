#!/usr/bin/ruby -w

def build_polymer(template, rules, steps)
	steps.times do 
		new_template = Hash.new(0)

		template.keys.each do |pattern|
			if rules.has_key?(pattern)
				left  = pattern[0]     + rules[pattern]
				right = rules[pattern] + pattern[1]

				new_template[left]  = new_template.has_key?(left)  ? new_template[left]  + template[pattern] : template[pattern]
				new_template[right] = new_template.has_key?(right) ? new_template[right] + template[pattern] : template[pattern]
			else
				new_template[pattern] = template[pattern]
			end
		end

		template = new_template.clone
	end

	result = Hash.new(0.0)
	template.each do |pattern, num|
		result[pattern[0]] += 0.5 * num
		result[pattern[1]] += 0.5 * num
	end

	result['N'] += 1
	result['B'] += 1
	counts = result.values.select { |v| v > 0 }.collect { |v| v.floor }.sort
	return counts.last - counts.first
end

template = File.readlines('input/14_input.txt')
						   .first
               .strip

rules = File.readlines('input/14_input.txt')
						.select  { |line| line.match(/->/) }
            .collect { |line| line.strip }
						.collect { |line| line.match(/(\w+) -> (\w+)/).captures }
						.to_h

template = 0.upto(template.length - 2)
            .collect { |idx| template[idx, 2] }
						.tally 

puts "A: #{build_polymer(template, rules, 10)}"
puts "B: #{build_polymer(template, rules, 40)}"
