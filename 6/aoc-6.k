import "stdlib.k"
import "file.k"

var text = with(File("aoc6.txt", F_RO, null), fn (f) => f.readAll())
# var text = 
# `Time:      7  15   30
# Distance:  9  40  200`

var lines = split(text, "\n");
var times = Arrays.map(splitOnWs(split(lines[0], ":")[1]), int);
var distances = Arrays.map(splitOnWs(split(lines[1], ":")[1]), int);

fn getDifferentWays(time, dist){
  return Math.ceil((time + Math.sqrt(time ** 2 - 4 * dist)) / 2) 
          - Math.floor((time - Math.sqrt(time ** 2 - 4 * dist)) / 2) 
          - 1
}

# PART 1 #
print "################## PART 1 ##################"

print "times: " + times
print "distances: " + distances

var tot = 1;
for(var i = 0; i < len(times); i+=1){
  tot *= getDifferentWays(times[i], distances[i])
}

print tot
print "################## PART 2 ##################"

# PART 2 #

var time = int(join(times, ""))
var distance = int(join(distances, ""))

print "time: " + time
print "distance: " + distance
print(getDifferentWays(time, distance))