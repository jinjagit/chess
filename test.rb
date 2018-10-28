require './pieces'

all_pieces = []

3.times {|i| all_pieces << Pawn.new("wp#{i}", "white")}
3.times {|i| all_pieces << Pawn.new("bp#{i}", "black")}
3.times {|i| all_pieces << Knight.new("wn#{i}", "white")}
3.times {|i| all_pieces << Knight.new("bn#{i}", "black")}
all_pieces[4].set_layer(3)
all_pieces[10].set_layer(3)

# -----------------------------------------------------------------

puts
puts "all pieces:"
all_pieces.each {|e| puts e.inspect}

puts
print "Any white knight have a z value > 0? "
puts all_pieces.any? {|e| e.class == Knight && e.color == 'white' && e.z > 0}
print "Any black knight have a z value > 0? "
puts all_pieces.any? {|e| e.class == Knight && e.color == 'black' && e.z > 0}

puts
a = all_pieces.detect {|e| e.class == Knight && e.color == 'black' && e.z > 0}
puts a.inspect
puts
