import "stdlib.k"
import "file.k"

# for testing
# var text = `467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..`

var text = with(File("aoc3.txt", F_RO, null), fn (f) => f.readAll())

var lines = Strings.split(text, "\n");
var lineLen = len(lines[0])

class Point {
    init(x, y){
        this.x = x;
        this.y = y;
    }
    toStr(){
        return "(" + this.x + ", " + this.y + ")";
    }
    _eq_(other){
        return this.x == other.x && this.y == other.y;
    }
    hash(){
        return this.x * 1000 + this.y;
    }
}

fn hash(key,capacity){
    return key.hash() % capacity;
}

var nums = Map()
var symbols = Map()
var gears = Map()

# update their hash functions to hash points
nums.hashFn = hash
symbols.hashFn = hash
gears.hashFn = hash

for (var y = 0; y<len(lines); y+=1){
  var line = lines[y]
  var x = 0
  while(x< lineLen){
    if("0" <= line[x] && line[x] <= "9"){
      var startx = x
      while(x < lineLen && "0" <= line[x] && line[x] <= "9"){
        x+=1
      }
      nums[Point(startx, y)] = int(line[startx:x])
      continue
    }
    if (line[x] != "."){
      symbols[Point(x, y)] = line[x]
    }
    if(line[x] == "*"){
      gears[Point(x, y)] = ArrayList()
    }
    x += 1
  }
}


var tot = ArrayList()



foreach(nums.entrySet, fn (e){
  var p = e.key
  var num = e.value
  var x = p.x
  var y = p.y
  var minx = max(0, x - 1)
  var miny = max(0, y - 1)
  var maxx = min(lineLen, x + len(str(num)) + 1 )
  var maxy = min(len(lines), y + 2)

  for (var x_ = minx; x_ < maxx; x_+=1){
    for (var y_ = miny; y_ < maxy; y_+=1){ 
      var p2 = Point(x_, y_)
      # print "checking: " + p2 + " for " + num + " at " + p
      if (!symbols.containsKey(p2)) continue

      tot.add(num)
      if(symbols[p2] == "*"){
        gears[p2].add(num)
      }
    }
  }
})

print sum(tot)


var gearTot = ArrayList()
print reduce(gears.entrySet, fn (a, b){
  if(len(b.value) == 2){
    return a + b.value[0] * b.value[1]
  }
  return a + 0
}, 0)