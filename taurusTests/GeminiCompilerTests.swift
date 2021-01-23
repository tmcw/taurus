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

         func testParseList() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("* Yes", true)),
                            Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 6, offset: 5)), children: [taurus.Node(data: taurus.Data.listItem(value: "Yes"), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 2, offset: 1)), children: [])])
                            )
         }

         func testParseLink() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("=> https://foo.com/", true)),
                            taurus.Node(
                                        data: taurus.Data.root,
                                        position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 20, offset: 19)),
                                        children: [
                                            taurus.Node(data: taurus.Data.link(value: "", url: "https://foo.com/"), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 3, offset: 2)
                                            ), children: [])]))
         }

         func testParseLinkWithDescription() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("=> https://foo.com/ Foo", true)),
                            taurus.Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 24, offset: 23)), children: [taurus.Node(data: taurus.Data.link(value: "Foo", url: "https://foo.com/"), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 3, offset: 2)), children: [])])
                            
                            )
         }

         func testPre() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()(
                                             """
     ```js
     test
     ```
     """, true)),
                            
                            taurus.Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 3, column: 4, offset: 14)), children: [taurus.Node(data: taurus.Data.pre(value: "\ntest", alt: Optional("js")), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 4, offset: 3)), children: [])])
                            )
         }

         func testText() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("yes", true)),
                            taurus.Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 4, offset: 3)), children: [taurus.Node(data: taurus.Data.text(value: "yes"), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 4, offset: 3)), children: [])])
                            )
         }

         func testQuote() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("> yes", true)),
                            taurus.Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 6, offset: 5)), children: [taurus.Node(data: taurus.Data.quote(value: "yes"), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 2, offset: 1)), children: [])])
                            )
         }

         func testEmptyQuote() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()(">", true)),
                            taurus.Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 2, offset: 1)), children: [taurus.Node(data: taurus.Data.quote(value: ""), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 2, offset: 1)), children: [])])
                            )
         }

         func testEmptyList() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("*", true)),
                            
                            Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 2, offset: 1)), children: [taurus.Node(data: taurus.Data.listItem(value: ""), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 2, offset: 1)), children: [])])
                            )
         }

         func testBreak() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("""
     Yes

     Hello
     """, true)),
                            taurus.Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 3, column: 6, offset: 10)), children: [taurus.Node(data: taurus.Data.text(value: "Yes"), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 4, offset: 3)), children: []), taurus.Node(data: taurus.Data.text(value: "Hello"), position: taurus.Position(start: taurus.Pos(line: 3, column: 1, offset: 5), end: taurus.Pos(line: 3, column: 6, offset: 10)), children: [])])
                            )
         }

         func testEmptyHeader() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("#", true)),
                            
                            taurus.Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 2, offset: 1)), children: [taurus.Node(data: taurus.Data.heading(value: "", rank: 1), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 2, offset: 1)), children: [])])
                            )
         }

         func testIgnoredClosingAlt() throws {
             XCTAssertEqual(compileGemini(tokens: parseGemini()("""
     ```js
     yeah
     ```js
     """, true)),
                           taurus.Node(data: taurus.Data.root, position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 3, column: 6, offset: 16)), children: [taurus.Node(data: taurus.Data.pre(value: "\nyeah", alt: Optional("js")), position: taurus.Position(start: taurus.Pos(line: 1, column: 1, offset: 0), end: taurus.Pos(line: 1, column: 4, offset: 3)), children: [])])
                            )
         }
}
