import Foundation

struct FeedData {
    let name: String
}

struct FeedDataProvider {
    
    func feedMockData() -> [FeedData] {
        return [
            FeedData(name: "Array"),
            FeedData(name: "Set"),
            FeedData(name: "Dictionary"),
            FeedData(name: "SuffixArray"),
            FeedData(name: "Item 5"),
            FeedData(name: "Item 6"),
            FeedData(name: "Item 7"),
            FeedData(name: "Item 8"),
            FeedData(name: "Item 9"),
            FeedData(name: "Item 10"),
            FeedData(name: "Item 11"),
            FeedData(name: "Item 12"),
            FeedData(name: "Item 13"),
            FeedData(name: "Item 14"),
            FeedData(name: "Item 15"),
            FeedData(name: "Item 16"),
            FeedData(name: "Item 17"),
            FeedData(name: "Item 18"),
            FeedData(name: "Item 19"),
            FeedData(name: "Item 20")
        ]
    }
}
