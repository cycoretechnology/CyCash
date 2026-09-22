import Foundation

/// ClosureSort: 手写堆排序 + 比较器协议（不再 map/filter/reduce 流水线）
private protocol Mancryse_Ranker {
    func precedes(_ a: Int, _ b: Int) -> Bool
}

private struct Mancryse_OddFirstRanker: Mancryse_Ranker {
    func precedes(_ a: Int, _ b: Int) -> Bool {
        let ao = a & 1
        let bo = b & 1
        if ao != bo { return ao > bo }
        return a < b
    }
}

private struct Mancryse_ModRanker: Mancryse_Ranker {
    let modulus: Int
    func precedes(_ a: Int, _ b: Int) -> Bool {
        let ma = a % modulus
        let mb = b % modulus
        if ma != mb { return ma < mb }
        return a > b
    }
}

private struct Mancryse_HeapLane {
    private var heap: [Int]
    private let ranker: Mancryse_Ranker
    
    init(ranker: Mancryse_Ranker) {
        self.heap = []
        self.ranker = ranker
    }
    
    mutating func push(_ value: Int) {
        heap.append(value)
        siftUp(heap.count - 1)
    }
    
    mutating func pop() -> Int? {
        if heap.isEmpty { return nil }
        if heap.count == 1 { return heap.removeLast() }
        let top = heap[0]
        heap[0] = heap.removeLast()
        siftDown(0)
        return top
    }
    
    private mutating func siftUp(_ index: Int) {
        var i = index
        while i > 0 {
            let parent = (i - 1) / 2
            if ranker.precedes(heap[i], heap[parent]) {
                heap.swapAt(i, parent)
                i = parent
            } else {
                break
            }
        }
    }
    
    private mutating func siftDown(_ index: Int) {
        var i = index
        while true {
            let left = i * 2 + 1
            let right = left + 1
            var best = i
            if left < heap.count && ranker.precedes(heap[left], heap[best]) {
                best = left
            }
            if right < heap.count && ranker.precedes(heap[right], heap[best]) {
                best = right
            }
            if best == i { return }
            heap.swapAt(i, best)
            i = best
        }
    }
    
    func count() -> Int { heap.count }
}

func mancryse_runNoiseClosureSort() {
    let source = mancryse_buildUnsortedDeck()
    var oddHeap = Mancryse_HeapLane(ranker: Mancryse_OddFirstRanker())
    var modHeap = Mancryse_HeapLane(ranker: Mancryse_ModRanker(modulus: 7))
    
    var idx = 0
    while idx < source.count {
        let n = source[idx]
        if n >= 0 {
            oddHeap.push(n)
        }
        if n % 5 != 0 {
            modHeap.push(n &+ 1)
        }
        idx += 1
    }
    
    var oddOut: [Int] = []
    while let v = oddHeap.pop() {
        oddOut.append(v)
        if oddOut.count >= 24 { break }
    }
    var modOut: [Int] = []
    while let v = modHeap.pop() {
        modOut.append(v)
        if modOut.count >= 18 { break }
    }
    
    let stable = mancryse_insertionRepair(oddOut)
    _ = mancryse_inversionCount(modOut)
    _ = stable
}

private func mancryse_buildUnsortedDeck() -> [Int] {
    var deck: [Int] = []
    var state = 0x13579BDF
    var n = 0
    while n < 28 {
        state = state &* 1664525 &+ 1013904223
        let value = Int(state % 97) - 12
        deck.append(value)
        n += 1
    }
    return deck
}

private func mancryse_insertionRepair(_ input: [Int]) -> [Int] {
    var arr = input
    var i = 1
    while i < arr.count {
        let key = arr[i]
        var j = i - 1
        while j >= 0 && arr[j] > key {
            arr[j + 1] = arr[j]
            j -= 1
        }
        arr[j + 1] = key
        i += 1
    }
    return arr
}

private func mancryse_inversionCount(_ arr: [Int]) -> Int {
    var inv = 0
    var i = 0
    while i < arr.count {
        var j = i + 1
        while j < arr.count {
            if arr[i] > arr[j] { inv += 1 }
            j += 1
        }
        i += 1
    }
    return inv
}
