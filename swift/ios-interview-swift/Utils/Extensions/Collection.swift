//
//  Collection.swift
//  TOCUtils
//
//  Created by Mike on 3/3/21.
//

public extension Collection {
    /// Is the collection not empty
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}

public extension Optional where Wrapped: Collection {
    /// True if the collection is nil or empty
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}

public extension Collection {
    /// Returns a subsequence by skipping elements from the end while predicate
    /// returns true and returning the remaining elements.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence
    /// as its argument and returns true if the element should be skipped or
    /// false if it should be included. Once the predicate returns false it will
    /// not be called again.
    func dropLast(while predicate: (Element) throws -> Bool) rethrows -> SubSequence {
        guard let index = try indices.reversed().first(where: { try !predicate(self[$0]) }) else {
            return self[startIndex..<endIndex]
        }
        return self[...index]
    }
}
