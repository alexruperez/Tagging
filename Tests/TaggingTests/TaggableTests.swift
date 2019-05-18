/**
 *  Tagging
 *  Copyright (c) John Sundell & alexruperez 2019
 *  Licensed under the MIT license (see LICENSE file)
 */

import XCTest
import Tagging

final class TaggableTests: XCTestCase {

    func testStringBasedTags() {
        struct Model: Taggable {
            let tags: Tags
        }

        let model = Model(tags: ["foo", "bar"])
        XCTAssertEqual(model.tags.first?.rawValue, "foo")
        XCTAssertEqual(model.tags.last?.rawValue, "bar")
    }

    func testIntBasedTags() {
        struct Model: Taggable {
            typealias RawTag = Int
            let tags: Tags
        }

        let model = Model(tags: [7, 9])
        XCTAssertEqual(model.tags.first?.rawValue, 7)
        XCTAssertEqual(model.tags.last?.rawValue, 9)
    }

    func testCodableTags() throws {
        struct Model: Taggable, Codable {
            typealias RawTag = UUID
            let tags: Tags
        }

        let model = Model(tags: [Tag(rawValue: UUID()), Tag(rawValue: UUID())])
        let data = try JSONEncoder().encode(model)
        let decoded = try JSONDecoder().decode(Model.self, from: data)
        XCTAssertEqual(model.tags.first, decoded.tags.first)
        XCTAssertEqual(model.tags.last, decoded.tags.last)
    }

    func testTagsEncodedAsSingleValue() throws {
        struct Model: Taggable, Codable {
            let tags: Tags
        }

        let model = Model(tags: ["foo", "bar"])
        let data = try JSONEncoder().encode(model)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: [String]]
        XCTAssertEqual(json?["tags"]?.first, "foo")
    }

    func testAllTestsRunOnLinux() {
        verifyAllTestsRunOnLinux()
    }
}

extension TaggableTests: LinuxTestable {
    static var allTests: [(String, (TaggableTests) -> () throws -> Void)] = [
        ("testStringBasedTags", testStringBasedTags),
        ("testIntBasedTags", testIntBasedTags),
        ("testCodableTags", testCodableTags),
        ("testTagsEncodedAsSingleValue", testTagsEncodedAsSingleValue)
    ]
}
