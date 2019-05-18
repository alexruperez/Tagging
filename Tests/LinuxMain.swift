/**
 *  Tagging
 *  Copyright (c) John Sundell & alexruperez 2019
 *  Licensed under the MIT license (see LICENSE file)
 */

import XCTest
import TaggingTests

var tests = [XCTestCaseEntry]()
tests += TaggableTests.allTests()
tests += CollectionTests.allTests()
XCTMain(tests)
