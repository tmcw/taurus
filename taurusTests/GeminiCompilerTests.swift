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
                       taurus.Node(
                           data: taurus.Data.root,
                           position: taurus.Position(
                               start: taurus.Pos(line: 1, column: 1, offset: 0),
                               end: taurus.Pos(line: 1, column: 8, offset: 7)
                           ),
                           children: [
                               taurus.Node(data: taurus.Data.heading(value: "Test", rank: 2),
                                           position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 3, offset: 2)), children: []),
                           ]
                       ))
    }

    /*

         func testParseList() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("* Yes", true)),
                            Node(type: "root", value: nil, children: [taurus.Node(type: "list", value: nil, children: [],
                                                                                  position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil)],
                            position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0),
                                                      end: Optional(taurus.Pos(line: 1, column: 6, offset: 5))), alt: nil, url: nil, rank: nil))
         }

         func testParseLink() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("=> https://foo.com/", true)),
                            Node(type: "root", value: nil, children: [taurus.Node(type: "link", value: Optional(""), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: Optional("https://foo.com/"), rank: nil)], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 20, offset: 19))), alt: nil, url: nil, rank: nil))
         }

         func testParseLinkWithDescription() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("=> https://foo.com/ Foo", true)),
                            Node(type: "root", value: nil, children: [taurus.Node(type: "link", value: Optional("Foo"), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: Optional("https://foo.com/"), rank: nil)], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 24, offset: 23))), alt: nil, url: nil, rank: nil))
         }

         func testPre() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()(
                                             """
     ```js
     test
     ```
     """, true)),
             Node(type: "root", value: nil, children: [
                     taurus.Node(type: "pre", value: Optional("\ntest"), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: Optional("js"), url: nil, rank: nil)
             ], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 3, column: 4, offset: 14))), alt: nil, url: nil, rank: nil))
         }

         func testText() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("yes", true)),
                            Node(type: "root", value: nil, children: [taurus.Node(type: "text", value: Optional("yes"), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil)], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 4, offset: 3))), alt: nil, url: nil, rank: nil))
         }

         func testQuote() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("> yes", true)),
                           Node(type: "root", value: nil, children: [taurus.Node(type: "quote", value: Optional("yes"), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil)], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 6, offset: 5))), alt: nil, url: nil, rank: nil))
         }

         func testEmptyQuote() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()(">", true)),
                           Node(type: "root", value: nil, children: [taurus.Node(type: "quote", value: Optional(""), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil)], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 2, offset: 1))), alt: nil, url: nil, rank: nil))
         }

         func testEmptyList() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("*", true)),
                          Node(type: "root", value: nil, children: [taurus.Node(type: "list", value: nil, children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil)], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 2, offset: 1))), alt: nil, url: nil, rank: nil))
         }

         func testBreak() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("""
     Yes

     Hello
     """, true)),

                         Node(type: "root", value: nil, children: [
                                 taurus.Node(type: "text", value: Optional("Yes"), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: nil),
                                 taurus.Node(type: "text", value: Optional("Hello"), children: [], position: taurus.Position(start: taurus.Pos(line: 3, column: 1, offset: 5), end: nil), alt: nil, url: nil, rank: nil)
                         ], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 3, column: 6, offset: 10))), alt: nil, url: nil, rank: nil))
         }

         func testEmptyHeader() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("#", true)),
                         Node(type: "root", value: nil, children: [taurus.Node(type: "heading", value: Optional(""), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: nil, url: nil, rank: Optional(1))], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 1, column: 2, offset: 1))), alt: nil, url: nil, rank: nil))
         }

         func testIgnoredClosingAlt() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("""
     ```js
     yeah
     ```js
     """, true)),

                 Node(type: "root", value: nil, children: [taurus.Node(type: "pre", value: Optional("\nyeah"), children: [], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: nil), alt: Optional("js"), url: nil, rank: nil)], position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: Optional(taurus.Pos(line: 3, column: 6, offset: 16))), alt: nil, url: nil, rank: nil))
         }
         */
}
