import "stdlib.k"
import "file.k"

# For testing
# var text = 
# `Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
# Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
# Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
# Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
# Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
# Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11`

var text = with(File("aoc4.txt", F_RO, null), fn (f) => f.readAll())

var lines = split(text, "\n");
var tot = 0
var m = Map.of({
    1, 1
})
for (var i = 0; i < len(lines); i+=1){
    var line = lines[i]
    var card = split(line, ": ")[1]
    var cardNums = split(card, " | ")
    var winningNums = Set.of(Arrays.map(splitOnWs(cardNums[0]), fn (x) => int(x)))
    var otherNums = Set.of(Arrays.map(splitOnWs(cardNums[1]), fn (x) => int(x)))

    # PART 1 #
    var gameNums = len(winningNums.intersection(otherNums))
    if(gameNums > 0){
        tot +=  (2 ** (gameNums - 1))
    }

    # PART 2 #
    var totCards = m.computeIfAbsent(i + 1, fn (k) => 1)
    for (var j = 1; j <= gameNums; j+=1){
      m.compute(j + i + 1, fn (k, v) => (v == null) ? totCards + 1 : v + totCards)
    }

}
print tot
print reduce(m.entrySet, fn (x, y){return x + y.value}, 0)
