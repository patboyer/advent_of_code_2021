#!/usr/bin/ruby -w

input = [
    '7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1',
'',
'22 13 17 11  0',
' 8  2 23  4 24',
'21  9 14 16  7',
' 6 10  3 18  5',
' 1 12 20 15 19',
'',
' 3 15  0  2 22',
' 9 18 13 17  5',
'19  8  7 25 23',
'20 11 10 24  4',
'14 21 16 12  6',
'',
'14 21 17 24  4',
'10 16 15  9 19',
'18  8 23 26 20',
'22 11 13  6  5',
' 2  0 12  3  7',
].collect { |line| line.strip }

def is_winner?(b)
  (0..b.length-1).to_a.each do |i|
    return true if b[i].count(-1) == b.length
    return true if b.collect { |row| row[i] }.count(-1) == b.length
  end

  return false
end

input = File.readlines("input/04_input.txt").collect { |s| s.strip }

plays  = input.shift.split(/,/).collect { |s| s.to_i }
boards = []
board  = []
input.shift

input.each do |line|
  if line == ''
    boards << board
    board = []
  else
    board << line.split(/\s+/).collect { |s| s.to_i }
  end
end

boards << board
scores = []
max_idx = boards[0].length - 1

plays.each do |play|
  (0..boards.length-1).to_a.each do |b|
    next if boards[b].nil?

    (0..max_idx).to_a.each do |row|
      (0..max_idx).to_a.each do |col|
        val = boards[b][row][col]
        boards[b][row][col] = (val == play) ? -1 : val
      end
    end

    if is_winner?(boards[b]) 
      result = boards[b].flatten.filter {|e| e != -1 }.sum
      boards[b] = nil
      scores << result * play
    end
  end
end

puts "A: #{scores.first}"
puts "B: #{scores.last}"
