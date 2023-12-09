import "stdlib.k" 
import "file.k"

var text = `0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45`

var text = with(File("aoc9.txt", F_RO, null), fn (f) => f.readAll())

var lines = map(split(text, "\n"), fn (line) => map(splitOnWs(line), int))

fn getDifferences(line){
  var differences = ArrayList()
  differences.add(ArrayList.of(line))
  var s = 1
  while(foreach(differences[-1], fn (x) => x != 0)){
    var diff = ArrayList()
    var curr = differences[-1]
    for (var i = 1; i < len(curr); i+=1){
      diff.add(curr[i] - curr[i-1])
    }
    differences.add(diff) 
  }
  
  differences[-1].addAtIndex(0, 0) # add to beginning
  differences[-1].add(0)
  for (var i = len(differences) - 2; i >= 0; i-=1){
    var curr = differences[i]
    var next = differences[i+1]
    curr.add(next[-1] + curr[-1])
    curr.addAtIndex(0, curr[0] - next[0] )
  }
  return differences[0]
}



print reduce(lines, fn (acc, line) => acc + getDifferences(line)[-1], 0)
print reduce(lines, fn (acc, line) => acc + getDifferences(line)[0], 0)
