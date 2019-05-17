/**
 *  Tagging
 *  Copyright (c) alexruperez 2019
 *  Licensed under the MIT license (see LICENSE file)
 */

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TaggableTests.allTests),
        testCase(CollectionTests.allTests)
    ]
}
#endif
