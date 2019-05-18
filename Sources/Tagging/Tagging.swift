/**
 *  Tagging
 *  Copyright (c) John Sundell & alexruperez 2019
 *  Licensed under the MIT license (see LICENSE file)
 */

import Foundation

// MARK: - Taggable

/// Taggable Protocol, RawTag type defaults to String.
public protocol Taggable {
    /// Tags type, defaults to String.
    associatedtype RawTag: Hashable = String
    /// Tags type alias.
    typealias Tags = [Tag<Self>]
    /// Tags of this instance.
    var tags: Tags { get }
}

// MARK: - Tag

/// Type-safe tag.
public struct Tag<Value: Taggable> {
    /// Tag raw value.
    public let rawValue: Value.RawTag

    /// Initializer with a raw value.
    public init(rawValue: Value.RawTag) {
        self.rawValue = rawValue
    }
}

// MARK: - Integer literal

extension Tag: ExpressibleByIntegerLiteral
where Value.RawTag: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Value.RawTag.IntegerLiteralType) {
        rawValue = .init(integerLiteral: value)
    }
}

// MARK: - String literal

extension Tag: ExpressibleByUnicodeScalarLiteral
where Value.RawTag: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: Value.RawTag.UnicodeScalarLiteralType) {
        rawValue = .init(unicodeScalarLiteral: value)
    }
}

extension Tag: ExpressibleByExtendedGraphemeClusterLiteral
where Value.RawTag: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: Value.RawTag.ExtendedGraphemeClusterLiteralType) {
        rawValue = .init(extendedGraphemeClusterLiteral: value)
    }
}

extension Tag: ExpressibleByStringLiteral
where Value.RawTag: ExpressibleByStringLiteral {
    public init(stringLiteral value: Value.RawTag.StringLiteralType) {
        rawValue = .init(stringLiteral: value)
    }
}

// MARK: - Equatable && Hashable

extension Tag: Equatable where Value.RawTag: Equatable {}
extension Tag: Hashable where Value.RawTag: Hashable {}

// MARK: - Codable

extension Tag: Codable where Value.RawTag: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(Value.RawTag.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

// MARK: - Collection extensions

/// Enum used to filter the search for multiple tags in the collection.
public enum Match {
    case all, any, none
}

extension Collection where Element: Taggable {
    /// An ordered, random-access collection of all tags.
    public var allTags: [Tag<Self.Element>] {
        return flatMap { $0.tags }
    }

    /// An ordered, random-access collection of all tags raw values.
    public var allRawTags: [Self.Element.RawTag] {
        return allTags.map { $0.rawValue }
    }

    /// An unordered collection of unique tags.
    public var uniqueTags: Set<Tag<Self.Element>> {
        return Set(allTags)
    }

    /// An unordered collection of unique tags raw values.
    public var uniqueRawTags: Set<Self.Element.RawTag> {
        return Set(allRawTags)
    }

    /// A collection whose elements are tag as key and occurrence frequency as value.
    public var tagsFrequency: [Tag<Self.Element>: Int] {
        return Dictionary(allTags.map { ($0, 1) }, uniquingKeysWith: +)
    }

    /// A collection whose elements are tag raw value as key and occurrence frequency as value.
    public var rawTagsFrequency: [Self.Element.RawTag: Int] {
        return Dictionary(allRawTags.map { ($0, 1) }, uniquingKeysWith: +)
    }

    /// An ordered, random-access collection of most popular tags,
    /// limited by a limit which defaults to 20.
    public func mostUsedTags(_ limit: Int = 20) -> [Tag<Self.Element>] {
        return tagsFrequency.sorted { $0.value > $1.value }.prefix(limit).map { $0.key }
    }

    /// An ordered, random-access collection of most popular tags raw values,
    /// limited by a limit which defaults to 20.
    public func mostUsedRawTags(_ limit: Int = 20) -> [Self.Element.RawTag] {
        return rawTagsFrequency.sorted { $0.value > $1.value }.prefix(limit).map { $0.key }
    }

    /// An ordered, random-access collection of least popular tags,
    /// limited by a limit which defaults to 20.
    public func leastUsedTags(_ limit: Int = 20) -> [Tag<Self.Element>] {
        return tagsFrequency.sorted { $0.value < $1.value }.prefix(limit).map { $0.key }
    }

    /// An ordered, random-access collection of least popular tags raw values,
    /// limited by a limit which defaults to 20.
    public func leastUsedRawTags(_ limit: Int = 20) -> [Self.Element.RawTag] {
        return rawTagsFrequency.sorted { $0.value < $1.value }.prefix(limit).map { $0.key }
    }

    /// An ordered, random-access collection of Taggable elements containing that tag raw value.
    public func tagged(with tag: Self.Element.RawTag) -> [Self.Element] {
        return tagged(with: Tag<Self.Element>(rawValue: tag))
    }

    /// An ordered, random-access collection of Taggable elements containing that tag.
    public func tagged(with tag: Tag<Self.Element>) -> [Self.Element] {
        return filter { $0.tags.contains(tag) }
    }

    /// An ordered, random-access collection of Taggable elements containing
    /// all, any or none of that tags raw values.
    public func tagged(with tags: [Self.Element.RawTag], match: Match = .any) -> [Self.Element] {
        return tagged(with: tags.map { Tag<Self.Element>(rawValue: $0) }, match: match)
    }

    /// An ordered, random-access collection of Taggable elements containing
    /// all, any or none of that tags.
    public func tagged(with tags: [Tag<Self.Element>], match: Match = .any) -> [Self.Element] {
        return filter {
            for tag in tags {
                if match == .all, !$0.tags.contains(tag) { return false }
                if match == .any, $0.tags.contains(tag) { return true }
                if match == .none, $0.tags.contains(tag) { return false }
            }
            return match != .any
        }
    }
}
