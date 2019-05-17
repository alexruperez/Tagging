/**
 *  Tagging
 *  Copyright (c) alexruperez 2019
 *  Licensed under the MIT license (see LICENSE file)
 */

import XCTest
@testable import TaggingTests

var tests = [XCTestCaseEntry]()
tests += TaggableTests.allTests()
tests += CollectionTests.allTests()
XCTMain(tests)
