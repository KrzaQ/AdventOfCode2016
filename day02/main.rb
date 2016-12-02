require 'matrix'

InputData = File.read('data.txt')
.split("\n")
.map{ |line| line.each_char.map(&:to_sym) }

KeyboardToPosTask1 = (0..2).map{ |x|
	(0..2).map{ |y|
		[(1 + x + y * 3).to_s, Matrix[[x, y]]]
	}
}.flatten(1).to_h

def sanitize_matrix_task_1(m)
	[m[0,0], m[0,1]].all?{|n| n >= 0 && n <= 2}
end

KeyboardToPosTask2 = {
	'1' => Matrix[[2,0]],
	'2' => Matrix[[1,1]],
	'3' => Matrix[[2,1]],
	'4' => Matrix[[3,1]],
	'5' => Matrix[[0,2]],
	'6' => Matrix[[1,2]],
	'7' => Matrix[[2,2]],
	'8' => Matrix[[3,2]],
	'9' => Matrix[[4,2]],
	'A' => Matrix[[1,3]],
	'B' => Matrix[[2,3]],
	'C' => Matrix[[3,3]],
	'D' => Matrix[[2,4]],
}

def sanitize_matrix_task_2(m)
	return false if [m[0,0], m[0,1]].any?{|n| n < 0 || n > 4}
	[m[0,0], m[0,1]]
	.map{|n| n - 2}
	.map(&:abs)
	.inject(:+) < 3
end

Direction = {
	R: Matrix[[ 1, 0]],
	L: Matrix[[-1, 0]],
	U: Matrix[[ 0,-1]],
	D: Matrix[[ 0, 1]],
}

def make_path(sanitizer, ktp, ptk)
	InputData
	.flatten
	.map
	.with_object({current: '5', arr: []}){ |dir, h|
		current = ktp[h[:current]]
		next_pos = current + Direction[dir]
		next_pos = send(sanitizer, next_pos) ? next_pos : current
		h[:arr].push next_pos
		h[:current] = ptk[next_pos]
		h
	}[:arr]
end

def solve_task(sanitizer, ktp)
	ptk = ktp.to_a.map(&:reverse).to_h
	path = make_path(sanitizer, ktp, ptk)

	InputData
	.map{|n| n.size }
	.inject([0]){ |t, n| t.push(t[-1] + n) }
	.drop(1)
	.map{|n| ptk[path[n-1]]}
	.join
end

puts 'Task 1: %s' % solve_task(:sanitize_matrix_task_1, KeyboardToPosTask1)
puts 'Task 2: %s' % solve_task(:sanitize_matrix_task_2, KeyboardToPosTask2)