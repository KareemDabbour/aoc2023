import "stdlib.k"
import "file.k"


var text = `32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483`

var text = with(File("aoc7.txt", F_RO, null), fn (f) => f.readAll())
var ORDER = Map()
var i = 1;
foreach("23456789TJQKA", fn (c){
  ORDER[c] = i;
  i+=1;
})
class Hand{

  
  init(handStr){
    this.handStr = handStr;
  }
  _lt_(other){
    for (var i = 0; i < len(this.handStr); i+=1){
      if (this.handStr[i] == other.handStr[i]){
        continue;
      }
      return ORDER[this.handStr[i]] < ORDER[other.handStr[i]];
    }
  }
  _gt_(other){
    for (var i = 0; i < len(this.handStr); i+=1){
      if (this.handStr[i] == other.handStr[i]){
        continue;
      }
      return ORDER[this.handStr[i]] > ORDER[other.handStr[i]];
    }
  }
  toStr(){
    return this.handStr;
  }

}


class HandType{
  init(name, value){
    this.name = name;
    this.value = value;
  }
  FIVE_OF_A_KIND = HandType("Five of a Kind", 10);
  FOUR_OF_A_KIND = HandType("Four of a Kind", 9);
  FULL_HOUSE = HandType("Full House", 8);
  THREE_OF_A_KIND = HandType("Three of a Kind", 7);
  TWO_PAIR = HandType("Two Pair", 6);
  ONE_PAIR = HandType("One Pair", 5);
  HIGH_CARD = HandType("High Card", 4);
  _lt_(other){
    return this.value < other.value;
  }
  _gt_(other){
    return this.value > other.value;
  }
  _eq_(other){
    return this.value == other.value;
  }
  _hash_(){
    return this.value + 31;
  }
  toStr(){
    return this.name;
  }
}



var lines = split(text, "\n");

var bids = Map()
var hands = Map.of({
  HandType.HIGH_CARD, ArrayList(),
  HandType.ONE_PAIR, ArrayList(),
  HandType.TWO_PAIR, ArrayList(),
  HandType.THREE_OF_A_KIND, ArrayList(),
  HandType.FULL_HOUSE, ArrayList(),
  HandType.FOUR_OF_A_KIND, ArrayList(),
  HandType.FIVE_OF_A_KIND, ArrayList()
})

fn determineHandType(hand){
  var counts = ArrayList.of(list(hand)).counts()
  var countLen = len(counts)
  if(countLen == 1){
    return HandType.FIVE_OF_A_KIND
  }
  if(countLen == 2){
    if(counts.entrySet[0].value == 4 || counts.entrySet[1].value == 4){
      return HandType.FOUR_OF_A_KIND
    }
    return HandType.FULL_HOUSE
  }
  if(countLen == 3){
    if(counts.entrySet[0].value == 3 || counts.entrySet[1].value == 3 || counts.entrySet[2].value == 3){
      return HandType.THREE_OF_A_KIND
    }
    return HandType.TWO_PAIR
  }
  if(countLen == 4){
    return HandType.ONE_PAIR
  }
  return HandType.HIGH_CARD
}

foreach(lines,fn (line) {
  var nums = splitOnWs(line)
  var type = determineHandType(nums[0])
  bids[nums[0]] = int(nums[1])
  hands[type].add(Hand(nums[0]))
})


var ranks = ArrayList()
hands.entrySet.foreach(fn(e){
  if (e.value.isEmpty()){
    return;
  }
# print e
  e.value.sort()

  e.value.foreach(fn (h){
    ranks.add(h.handStr)
  })
})
var i = 0;
print ranks
  .map(fn (x) => bids[x])
  .reduce(fn (acc, bid) => acc + bid * (i += 1), 0)

########################### PART 2 ###########################

var hands = Map.of({
  HandType.HIGH_CARD, ArrayList(),
  HandType.ONE_PAIR, ArrayList(),
  HandType.TWO_PAIR, ArrayList(),
  HandType.THREE_OF_A_KIND, ArrayList(),
  HandType.FULL_HOUSE, ArrayList(),
  HandType.FOUR_OF_A_KIND, ArrayList(),
  HandType.FIVE_OF_A_KIND, ArrayList()
})
var bids = Map()
ORDER = Map()
foreach("J23456789TQKA", fn (c){
  ORDER[c] = i;
  i+=1;
})

fn determineHandTypeWithWildcard(hand){
  var counts = ArrayList.of(list(hand)).counts().sortByValue(SortOrder.DESC)
  var add = counts.remove("J")
  add = add ? add : 0
  if(add == 5){
    return HandType.FIVE_OF_A_KIND
  }

  var e = counts.entrySet[0]
  e.value += add
  if (e.value == 5){
    return HandType.FIVE_OF_A_KIND;
  }
  if (e.value == 4){
    return HandType.FOUR_OF_A_KIND;
  }
  if (e.value == 3){
    if(counts.entrySet[1].value == 2){
      return HandType.FULL_HOUSE
    }
    return HandType.THREE_OF_A_KIND;
  }
  if (e.value == 2){
    if(counts.entrySet[1].value == 2){
      return HandType.TWO_PAIR
    }
    return HandType.ONE_PAIR;
  }
  
  return HandType.HIGH_CARD;

}

foreach(lines,fn (line) {
  var nums = splitOnWs(line)
  var type = determineHandTypeWithWildcard(nums[0])
  bids[nums[0]] = int(nums[1])
  hands[type].add(Hand(nums[0]))
})

var ranks = ArrayList()
hands.entrySet.foreach(fn(e){
  e.value
    .sort()
    .foreach(fn (h){
        ranks.add(h.handStr)
      })
})
i = 0;
print ranks
  .map(fn (x) => bids[x])
  .reduce(fn (acc, bid) => acc + bid * (i += 1), 0)
