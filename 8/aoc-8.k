import "stdlib.k"
import "file.k"

var text = `LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)`

var text = with(File("aoc8.txt", F_RO, null), fn (f) => f.readAll())

var lines = split(text, "\n\n")
var moves = map(list(lines[0]), fn(x) => x == "R" ? 1 : 0)
var rules = Map()
var starts = ArrayList()

class Rule{
  init(name, left, right){
    this.name = name;
    this.left = left;
    this.right = right;
  }
  toStr(){
    return this.name + " = (" + this.left + ", " + this.right + ")";
  }
}

foreach(split(lines[1], "\n"), 
  fn (line){
    var rule = split(line, " = ")
    var LR = split(rule[1], ", ")
    rules[rule[0]] = {LR[0][1:], LR[1][:-2]}
    if(rule[0][-1] == "A"){
      starts.add(rule[0])
    }
  }
)

var i = 1 
var curr = rules["SBA"]

while(!foreach(moves,fn (move){
  i+=1
  if(curr[move]== "SSZ"){
    return true;
  }
  curr = rules[curr[move]]
})){}

print i 


# starts = {"AAA", "SSZ"}
var pathLens = ArrayList()

foreach(starts, fn (start){
  var k = 0
  var curr = rules[start]
  while(!foreach(moves,
    fn (move){
      k+=1
      if(curr[move][-1] == "Z"){
        return true;
      }
      curr = rules[curr[move]]
    })){}
  # print start + ": " + k
  pathLens.add(k)
})

print Math.lcmAll(pathLens)