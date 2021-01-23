//
//  GeminiResponseParserTest.swift
//  taurusTests
//
//  Created by Tom MacWright on 1/23/21.
//

import XCTest
@testable import taurus

class GeminiResponseParserTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResponseParser() throws {
        XCTAssertEqual(parseResponse(content: "200 text/gemini\r## Test"), taurus.GeminiDocument(
                        status: 200,
                        mediaType: "text/gemini",
                        body: "## Test",
                        tree: taurus.Node(
                           data: taurus.Data.root,
                           position: taurus.Position(
                               start: taurus.Pos(line: 1, column: 1, offset: 0),
                               end: taurus.Pos(line: 1, column: 8, offset: 7)
                           ),
                           children: [
                               taurus.Node(data: taurus.Data.heading(value: "Test", rank: 2),
                                           position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 3, offset: 2)), children: []),
                           ]
                        )));
    }

}
