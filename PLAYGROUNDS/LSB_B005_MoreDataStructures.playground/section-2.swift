import UIKit

/*
//  More Data Structures
//
//  Suggested Reading:
//  http://www.objc.io/books/ (Chapter 9)
//    (Functional Programming in Swift, by Chris Eidhof, Florian Kugler, and Wouter Swierstra)
/===================================*/


/*---------------------------------------------------------/
//  Tries
//
//  What's a Trie?
//
//  In computer science, a trie, also called digital tree and sometimes radix tree or prefix tree (as they can be searched by prefixes), is an ordered tree data structure that is used to store a dynamic set or associative array where the keys are usually strings. Unlike a binary search tree, no node in the tree stores the key associated with that node; instead, its position in the tree defines the key with which it is associated. All the descendants of a node have a common prefix of the string associated with that node, and the root is associated with the empty string. Values are normally not associated with every node, only with leaves and some inner nodes that correspond to keys of interest. For the space-optimized presentation of prefix tree, see compact prefix tree.

//  The term trie comes from re*trie*val. This term was coined by Edward Fredkin, who pronounces it /ˈtriː/ "tree" as in the word retrieval. However, other authors pronounce it /ˈtraɪ/ "try", in an attempt to distinguish it verbally from "tree".
//  - Wikipedia (2015/01/18)
//    https://en.wikipedia.org/wiki/Trie
//
/---------------------------------------------------------*/

struct Trie<T: Hashable> {
  typealias Children = [T: Trie<T>]
  
  var isElem: Bool
  var children: Children
  
  subscript(index: T) -> Trie<T>? {
    return self.children[index]
  }
}


/*---------------------------------------------------------/
//  Create an empty trie
/---------------------------------------------------------*/
func empty<T: Hashable>() -> Trie<T> {
  return Trie(isElem: false, children: Trie.Children())
}
let emptyTrie: Trie<Character> = empty()


/*---------------------------------------------------------/
//  List trie elements
/---------------------------------------------------------*/
func elements<T: Hashable>(trie: Trie<T>) -> [[T]] {
  var result: [[T]] = trie.isElem ? [[]] : []
  for (key, value) in trie.children {
    result += elements(value).map { xs in [key] + xs }
  }
  return result
}

elements(emptyTrie)


/*---------------------------------------------------------/
//  Required Array extension: Head-Tail
/---------------------------------------------------------*/
extension Array {
  var decompose: (head: T, tail: [T])? {
    return (count > 0) ? (self[0], Array(self[1..<count])) : nil
  }
}


// Sum, as an exercise
func sum(xs: [Int]) -> Int {
  if let (head, tail) = xs.decompose {
    return (head + sum(tail))
  } else {
    return 0
  }
}

sum([])
sum([42])
sum([1, 3, 5])


/*---------------------------------------------------------/
//  Insert into trie
/---------------------------------------------------------*/
func trieInsert<T: Hashable>(key: [T], trie: Trie<T>) -> Trie<T> {
  if let (head, tail) = key.decompose {
    let isLast = key.count == 1
    var trieCopy = trie
    
    // key found
    if var subtrie = trie.children[head] {
      if isLast { subtrie.isElem = true }
      trieCopy.children[head] = trieInsert(tail, subtrie)
    } else {
      // key not found
      var newSubtrie = Trie<T>(isElem: isLast, children: [T : Trie<T>]())
      trieCopy.children[head] = trieInsert(tail, newSubtrie)
    }
    return trieCopy
  } else {
    // no more keys
    return trie
  }
}

// test with "cat"
var root: Trie<Character> = empty()
let cat = trieInsert(["c", "a", "t"], root)
cat.isElem
cat.children["c"]!
cat.children["c"]!.isElem
cat.children["c"]!.children["a"]!
cat.children["c"]!.children["a"]!.isElem
cat.children["c"]!.children["a"]!.children["t"]!
cat.children["c"]!.children["a"]!.children["t"]!.isElem
root.children

// add another word, "car"
let catr = trieInsert(["c", "a", "r"], cat)
catr.isElem
catr.children["c"]!
catr.children["c"]!.isElem
catr.children["c"]!.children["a"]!
catr.children["c"]!.children["a"]!.isElem
catr.children["c"]!.children["a"]!.children
catr.children["c"]!.children["a"]!.children["r"]!
catr.children["c"]!.children["a"]!.children["r"]!.isElem

// "cat" remains element:
catr.children["c"]!.children["a"]!.children["t"]!
catr.children["c"]!.children["a"]!.children["t"]!.isElem


// Also, can use custom subscript notation
catr["c"]!





