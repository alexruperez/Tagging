/**
 *  Tagging
 *  Copyright (c) alexruperez 2019
 *  Licensed under the MIT license (see LICENSE file)
 */

import XCTest
@testable import Tagging

final class CollectionTests: XCTestCase {

    struct Model: Taggable, Equatable {
        let tags: Tags
    }

    func testAllTags() {
        let modelA = Model(tags: ["foo", "bar"])
        let modelB = Model(tags: ["1", "2", "3"])
        let allTags = [modelA, modelB].allTags
        XCTAssertEqual(allTags.first, modelA.tags.first)
        XCTAssertEqual(allTags.last, modelB.tags.last)
    }

    func testAllRawTags() {
        let modelA = Model(tags: ["foo", "bar"])
        let modelB = Model(tags: ["1", "2", "3"])
        let allRawTags = [modelA, modelB].allRawTags
        XCTAssertEqual(allRawTags.first, "foo")
        XCTAssertEqual(allRawTags.last, "3")
    }

    func testUniqueTags() {
        let modelA = Model(tags: ["3", "foo", "bar"])
        let modelB = Model(tags: ["1", "2", "3"])
        let uniqueTags = [modelA, modelB].uniqueTags
        XCTAssert(uniqueTags.contains(modelA.tags.first!))
        XCTAssert(uniqueTags.contains(modelB.tags.last!))
    }

    func testUniqueRawTags() {
        let modelA = Model(tags: ["3", "foo", "bar"])
        let modelB = Model(tags: ["1", "2", "3"])
        let uniqueTags = [modelA, modelB].uniqueRawTags
        XCTAssert(uniqueTags.contains("2"))
    }

    func testTagsFrequency() {
        let modelA = Model(tags: ["3", "foo", "bar"])
        let modelB = Model(tags: ["1", "2", "3"])
        let tagsFrequency = [modelA, modelB].tagsFrequency
        XCTAssertEqual(tagsFrequency[modelA.tags.first!], 2)
    }

    func testRawTagsFrequency() {
        let modelA = Model(tags: ["3", "foo", "bar"])
        let modelB = Model(tags: ["1", "2", "3"])
        let rawTagsFrequency = [modelA, modelB].rawTagsFrequency
        XCTAssertEqual(rawTagsFrequency["3"], 2)
    }

    func testMostUsedTags() {
        let modelA = Model(tags: ["3", "foo", "bar"])
        let modelB = Model(tags: ["1", "2", "3", "4", "4", "4"])
        let mostUsedTags = [modelA, modelB].mostUsedTags()
        XCTAssertEqual(mostUsedTags.first, modelB.tags.last)
    }

    func testMostUsedRawTags() {
        let modelA = Model(tags: ["3", "foo", "bar"])
        let modelB = Model(tags: ["1", "2", "4", "4", "4", "3"])
        let mostUsedRawTags = [modelA, modelB].mostUsedRawTags()
        XCTAssertEqual(mostUsedRawTags.first, "4")
    }

    func testMostUsedTagsLimit() {
        let modelA = Model(tags: ["3", "foo", "bar"])
        let modelB = Model(tags: ["1", "2", "3", "4", "4", "4"])
        let mostUsedTags = [modelA, modelB].mostUsedTags(6)
        XCTAssertEqual(mostUsedTags.count, 6)
    }

    func testMostUsedRawTagsLimit() {
        let modelA = Model(tags: ["3", "foo", "bar"])
        let modelB = Model(tags: ["1", "2", "3", "4", "4", "4"])
        let mostUsedRawTags = [modelA, modelB].mostUsedRawTags(6)
        XCTAssertEqual(mostUsedRawTags.count, 6)
    }

    func testLeastUsedTags() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let leastUsedTags = [modelA, modelB].leastUsedTags()
        XCTAssertEqual(leastUsedTags.first, modelB.tags.first)
    }

    func testLeastUsedRawTags() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let leastUsedRawTags = [modelA, modelB].leastUsedRawTags()
        XCTAssertEqual(leastUsedRawTags.first, "1")
    }

    func testLeastUsedTagsLimit() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let mostUsedTags = [modelA, modelB].leastUsedTags(6)
        XCTAssertEqual(mostUsedTags.count, 6)
    }

    func testLeastUsedRawTagsLimit() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let mostUsedRawTags = [modelA, modelB].leastUsedRawTags(6)
        XCTAssertEqual(mostUsedRawTags.count, 6)
    }

    func testTaggedWithRawTag() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let tagged = [modelA, modelB].tagged(with: "foo")
        XCTAssert(tagged.contains(modelA))
        XCTAssertFalse(tagged.contains(modelB))
    }

    func testTaggedWithTag() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let tagged = [modelA, modelB].tagged(with: modelB.tags.first!)
        XCTAssert(tagged.contains(modelB))
        XCTAssertFalse(tagged.contains(modelA))
    }

    func testTaggedWithRawTags() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let tagged = [modelA, modelB].tagged(with: ["foo"])
        XCTAssert(tagged.contains(modelA))
        XCTAssertFalse(tagged.contains(modelB))
    }

    func testTaggedWithTags() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let tagged = [modelA, modelB].tagged(with: modelA.tags.first!)
        XCTAssert(tagged.contains(modelB))
        XCTAssert(tagged.contains(modelA))
    }

    func testTaggedAllWithRawTags() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let tagged = [modelA, modelB].tagged(with: ["foo", "bar"], match: .all)
        XCTAssert(tagged.contains(modelA))
        XCTAssertFalse(tagged.contains(modelB))
    }

    func testTaggedAllWithRawTagsNotFound() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let tagged = [modelA, modelB].tagged(with: ["foo", "bar", "unknown"], match: .all)
        XCTAssertFalse(tagged.contains(modelA))
        XCTAssertFalse(tagged.contains(modelB))
    }

    func testTaggedNoneWithTags() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let tagged = [modelA, modelB].tagged(with: [modelA.tags.first!], match: .none)
        XCTAssertFalse(tagged.contains(modelB))
        XCTAssertFalse(tagged.contains(modelA))
    }

    func testTaggedWithEmptyRawTags() {
        let modelA = Model(tags: ["3", "foo", "foo", "bar", "bar"])
        let modelB = Model(tags: ["1", "2", "2", "3", "4", "4", "4"])
        let tagged = [modelA, modelB].tagged(with: ["unknown"])
        XCTAssertFalse(tagged.contains(modelA))
        XCTAssertFalse(tagged.contains(modelB))
    }

    func testAllTestsRunOnLinux() {
        verifyAllTestsRunOnLinux()
    }

}

extension CollectionTests: LinuxTestable {
    static var allTests: [(String, (CollectionTests) -> () throws -> Void)] = [
        ("testAllTags", testAllTags),
        ("testAllRawTags", testAllRawTags),
        ("testUniqueTags", testUniqueTags),
        ("testUniqueRawTags", testUniqueRawTags),
        ("testTagsFrequency", testTagsFrequency),
        ("testRawTagsFrequency", testRawTagsFrequency),
        ("testMostUsedTags", testMostUsedTags),
        ("testMostUsedRawTags", testMostUsedRawTags),
        ("testMostUsedTagsLimit", testMostUsedTagsLimit),
        ("testMostUsedRawTagsLimit", testMostUsedRawTagsLimit),
        ("testLeastUsedTags", testLeastUsedTags),
        ("testLeastUsedRawTags", testLeastUsedRawTags),
        ("testLeastUsedTagsLimit", testLeastUsedTagsLimit),
        ("testLeastUsedRawTagsLimit", testLeastUsedRawTagsLimit),
        ("testTaggedWithRawTag", testTaggedWithRawTag),
        ("testTaggedWithTag", testTaggedWithTag),
        ("testTaggedWithRawTags", testTaggedWithRawTags),
        ("testTaggedWithTags", testTaggedWithTags),
        ("testTaggedAllWithRawTags", testTaggedAllWithRawTags),
        ("testTaggedAllWithRawTagsNotFound", testTaggedAllWithRawTagsNotFound),
        ("testTaggedNoneWithTags", testTaggedNoneWithTags),
        ("testTaggedWithEmptyRawTags", testTaggedWithEmptyRawTags)
    ]
}
