import "stdlib.k"
import "file.k"

var text = with(File("aoc2.txt", F_RO, null), fn (f) => f.readAll())

var lines = Strings.split(text, "\n");

var m = Map();
var originalMap = Map.of({
    "blue", 14,
    "red", 12,
    "green", 13
})
var possibleGames = ArrayList();

for (var i = 0; i < len(lines); i +=1){
  var line = lines[i]
  var game = Strings.split(line, ": ")
  var gameNum = Strings.split(game[0], " ")[-1]
  var subGames = Strings.split(game[1], ";")
  var isPossible = true;
  for(var j = 0; j < len(subGames); j+=1){
    var subGame = Strings.split(subGames[j], ",")
    for (var x = 0; x < len(subGame); x+=1){
      var subGameNumColor = Strings.split(Strings.trim(subGame[x]), " ")
      if(originalMap[subGameNumColor[1]] < int(subGameNumColor[0])){
        isPossible = false;
        break;
      }
    }
    if(!isPossible){
      break;
    }

  }
  if(isPossible)
    possibleGames.add(int(gameNum))
}

print reduce(possibleGames, fn (x, y){return x + y}, 0)


#part 2

var powerSet = ArrayList();
var originalMap = Map.of({
    "blue", 0,
    "red", 0,
    "green", 0
})

for (var i = 0; i < len(lines); i +=1){
  var line = lines[i]
  var game = Strings.split(line, ": ")
  var gameNum = Strings.split(game[0], " ")[-1]
  var subGames = Strings.split(game[1], ";")
  var originalMap = Map.of({
    "blue", 0,
    "red", 0,
    "green", 0
  })
  for(var j = 0; j < len(subGames); j+=1){
    var subGame = Strings.split(subGames[j], ",")
    for (var x = 0; x < len(subGame); x+=1){
      var subGameNumColor = Strings.split(Strings.trim(subGame[x]), " ")
      if (originalMap[subGameNumColor[1]] < int(subGameNumColor[0])){
        originalMap[subGameNumColor[1]] = int(subGameNumColor[0])
      }
    }
  }

  powerSet.add(reduce(originalMap.entrySet, fn (x, y){return x * y.value}, 1))
}
print reduce(powerSet, fn (x, y){return x + y}, 0)