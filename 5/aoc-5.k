import "stdlib.k"
import "file.k"


var text = with(File("aoc5.txt", F_RO, null), fn (f) => f.readAll())

var dtext = `seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4`


class Range{
  init(source, dest, range){
    this.source = source;
    this.dest = dest;
    this.range = range;
  }
  isInRange(num){
    return num >= this.source && num <= this.source + this.range;
  }
  returnDest(num){
    return this.dest + (num - this.source);
  }
  toStr(){
    return this.source + " " + this.dest + " " + this.range;
  }
}

class Pair{
  init(start, end){
    this.start = start;
    this.end = end;
  }
  toStr(){
    return this.start + " " + this.end;
  }
  _lt_(other){
    return this.start < other.start;
  }
  _gt_(other){
    return this.start > other.start;
  }
}

var blocks = split(text, "\n\n")
var seedRanges = map(splitOnWs(split(blocks[0], ": ")[1]), int);
var seedSet = Set.of(seedRanges)

var seedPairs = ArrayList()
for (var i = 0; i < len(seedRanges); i+=2){
  seedPairs.add(Pair(seedRanges[i], seedRanges[i] + seedRanges[i+1]))
}


# PART 1 #

for (var i = 0; i < len(blocks); i+=1){
  var ranges = ArrayList()
  var lines = split(blocks[i], "\n")[1:]
  for (var j = 0; j < len(lines); j+=1){
    var nums = map(splitOnWs(lines[j]), fn(x) => int(x))
    ranges.add(Range(nums[1], nums[0], nums[-1]))
  }
  var new = ArrayList()
  seedSet.foreach(fn (seed){
    if(!ranges.foreach(fn(range){
      if (range.isInRange(seed)){
        new.add(range.returnDest(seed))
        return true
      }
    })) new.add(seed)
  })

  seedSet = new
}

print Arrays.min(seedSet)

# PART 2 #

for (var i = 0; i < len(blocks); i+=1){
  var ranges = ArrayList()
  var lines = split(blocks[i], "\n")[1:]
  for (var j = 0; j < len(lines); j+=1){
    var nums = map(splitOnWs(lines[j]), fn(x) => int(x))
    ranges.add(Range(nums[1], nums[0], nums[-1]))
  }
  var new = ArrayList()
  while(len(seedPairs) > 0){
    var r = seedPairs.pop()
    var s = r.start
    var e = r.end
    if(!ranges.foreach(fn(range){
      var os = max(s, range.source)
      var oe = min(e, range.source + range.range)
      if (os < oe){
        new.add(Pair(range.returnDest(os), range.returnDest(oe)))
        if (os > s){
          seedPairs.add(Pair(s, os))
        }
        if(e > oe){
          seedPairs.add(Pair(oe, e))
        }
        return true
      }
    })) new.add(r)
  }
  seedPairs = new
}

print seedPairs.reduce(fn (acc, seed) => seed.start < acc ? seed.start : acc, Math.INF)