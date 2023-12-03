import "stdlib.k"
import "file.k"

var text = with(File("aoc1.txt", F_RO, null), fn (f) => f.readAll())

var lines = Strings.split(text, "\n");

var nums = ArrayList()

####### PART 1 #######

for (var i = 0; i < len(lines); i+=1){
    var line = lines[i]
    var s = ArrayList()
    for (var j = 0; j < len(line); j+=1){
        var c = line[j]
        if(c >= "0" && c <= "9"){
            s.add(c)
        }
    }
    nums.add(int(s[0] + s[-1]))
}


fn sum (arr) {
    var ret = 0
    for (var i = 0; i < len(arr); i+=1){
        ret += arr[i]
    }
    return ret
}

print "PART 1: " + sum(nums)

####### PART 2 #######
var numLenMap = {
    1,2,2,4,3,3,2,4,4,3
}

var setStart = Set.of({
    "o", "t", "f", "s", "e", "n"
})

fn checkStr(string, index, arr){
    switch(string[index]){
        case "o"{
            if (string[index:index+3] == "one"){
                arr.add("1")
                return 1
            }
        }
        case "t"{

            if (string[index:index+3] == "two"){
                arr.add("2")
                return 2
            }
            else if (string[index:index+5] == "three"){
                arr.add("3")
                return 3
            }  
        }
        case "f"{
            if (string[index:index+4] == "four"){
                arr.add("4")
                return 4
            }
            else if (string[index:index+4] == "five"){
                arr.add("5")
                return 5
            }
        }
        case "s"{
            if (string[index:index+3] == "six"){
                arr.add("6")
                return 6
            }
            else if (string[index:index+5] == "seven"){
                arr.add("7")
                return 7
            }
        }
        case "e"{
            if (string[index:index+5] == "eight"){
                arr.add("8")
                return 8
            }
        }
        case "n"{
            if (string[index:index+4] == "nine"){
                arr.add("9")
                return 9
            }
        }
    }
    return 0
}

nums.clear()

for (var i = 0; i < len(lines); i+=1){
    var line = lines[i]
    var s = ArrayList()
    var j = 0;
    while (j < len(line)){
        var c = line[j]
        var inc = 1
        if(setStart.contains(c)){
            inc = numLenMap[checkStr(line, j, s)]
        }else if(c >= "0" && c <= "9"){
            s.add(c)
        }
        j+=inc
    }
    nums.add(int(s[0] + s[-1]))
}
print "PART 2: " + sum(nums)