//
//  GeminiCompilerTests.swift
//  taurusTests
//
//  Created by Tom MacWright on 1/13/21.
//

@testable import taurus
import XCTest

class GeminiCompilerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParseHeader() throws {
        XCTAssertEqual(compileGemini(tokens: parseGemini()("## Test", true)),
                       Node(type: "root", value: nil, children: [taurus.Node(type: "heading", value: Optional("Test"), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: Optional(2))], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 8, offset: 7))), alt: nil, url: nil, rank: nil))
    }

    func testParseList() throws {
        XCTAssertEqual(compileGemini(tokens: parseGemini()("* Yes", true)),
                       Node(type: "root", value: nil, children: [taurus.Node(type: "list", value: nil, children: [],
                                                                             position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil)],
                       position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0),
                                                 end: Optional(taurus.Pos(line: 1, column: 6, offset: 5))), alt: nil, url: nil, rank: nil))
    }

    func testParseQuote() throws {
        XCTAssertEqual(compileGemini(tokens: parseGemini()("> Yes", true)),
                       Node(type: "root", value: nil, children: [
                           taurus.Node(type: "quote", value: Optional(""),
                                       children: [],
                                       position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil),
                       ],
                       position: taurus.Position(
                           start: taurus.Pos(line: 1, column: 1, offset: 0),
                           end: Optional(taurus.Pos(line: 1, column: 6, offset: 5)
                           )
                       ), alt: nil, url: nil, rank: nil))
    }
    
    func testParseLink() throws {
        XCTAssertEqual(compileGemini(tokens: parseGemini()("=> https://foo.com/", true)),
                       Node(type: "root", value: nil, children: [taurus.Node(type: "link", value: Optional(""), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil)], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 20, offset: 19))), alt: nil, url: nil, rank: nil))
    }
    
    /*func testPre() throws {
        XCTAssertEqual(compileGemini(tokens: parseGemini()(
                                        """
```js
test
```
""", true)),
                       Node(type: "root", value: nil, children: [taurus.Node(type: "link", value: Optional(""), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil)], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 20, offset: 19))), alt: nil, url: nil, rank: nil))
    } */
}
