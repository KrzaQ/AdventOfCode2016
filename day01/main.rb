require 'matrix'
InputData = File.read('data.txt')
	.strip
	.split(", ")
	.map{|s| /(\w)(\d+)/.match(s)[1..2] }
	.map{|k,v| [k.to_sym, v.to_i] }

Movement = {
	n: Matrix[[1, 0]],
	w: Matrix[[0, -1]],
	s: Matrix[[-1, 0]],
	e: Matrix[[0, 1]]
}

def change_direction(change, curr)
	arr = [:n, :w, :s, :e]
	ch = change == :L ? 1 : -1
	id = arr.index(curr) + ch
	arr[id % arr.size]
end

def distance(m)
	(m[0,0] + m[0,1]).abs
end

AllFields = InputData.inject([[Matrix[[0,0]], :n]]){ |t, c|
	dir = change_direction(c.first, t.last.last)
	steps = (1..c.last).map{ |n| [ t.last.first + n * Movement[dir], dir ] }.to_a
	t + steps
}

FirstDupe = AllFields
	.each_with_index
	.map{ |x, i| [x.first, i] }
	.find{|x, i|
		AllFields.find_index{|el| el.first == x } != i
	}

puts 'Part1: %s' % distance(AllFields.last.first)
puts 'Part2: %s' % distance(FirstDupe.first)
