//
//  GeminiParser.swift
//  taurusTests
//
//  Created by Tom MacWright on 1/8/21.
//

import XCTest
@testable import taurus

class GeminiParserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPreSequence() throws {
        XCTAssertEqual(parseGemini()("```", true), [
            taurus.Token(
                start: Pos(line: 1, column: 1, offset:0),
                end: Pos(line:1, column: 4, offset:3),
                type: "preSequence",
                value: "```"),
            taurus.Token(
                start: Pos(line: 1, column: 4, offset:3),
                end: Pos(line:1, column: 4, offset:3),
                type: "eof",
                value: "")
        ])
    }
    
    func testPreSequenceWithAlt() throws {
        XCTAssertEqual(parseGemini()("```js", true), [
            taurus.Token(
                start: Pos(line: 1, column: 1, offset:0),
                end: Pos(line:1, column: 4, offset:3),
                type: "preSequence",
                value: "```"),
            taurus.Token(
                start: Pos(line: 1, column: 4, offset:3),
                end: Pos(line:1, column: 6, offset:5),
                type: "preAlt",
                value: "js"),
            taurus.Token(
                start: Pos(line: 1, column: 6, offset:5),
                end: Pos(line:1, column: 6, offset:5),
                type: "eof",
                value: "")
        ])
    }
    
    func testHeadingSequence() throws {
        XCTAssertEqual(parseGemini()("## Test", true), [
            taurus.Token(
                start: Pos(line: 1, column: 1, offset:0),
                end: Pos(line:1, column: 3, offset:2),
                type: "headingSequence",
                value: "##"),
            taurus.Token(
                start: Pos(line: 1, column: 3, offset:2),
                end: Pos(line:1, column: 4, offset:3),
                type: "whitespace",
                value: " "),
            taurus.Token(
                start: Pos(line: 1, column: 4, offset:3),
                end: Pos(line:1, column: 8, offset:7),
                type: "headingText",
                value: "Test"),
            taurus.Token(
                start: Pos(line: 1, column: 8, offset:7),
                end: Pos(line:1, column: 8, offset:7),
                type: "eof",
                value: "")])
    }
    
    func testListSequence() throws {
        XCTAssertEqual(parseGemini()("* Test", true), [
            taurus.Token(
                start: Pos(line: 1, column: 1, offset:0),
                end: Pos(line:1, column: 2, offset:1),
                type: "listSequence",
                value: "*"),
            taurus.Token(
                start: Pos(line: 1, column: 2, offset:1),
                end: Pos(line:1, column: 3, offset:2),
                type: "whitespace",
                value: " "),
            taurus.Token(
                start: Pos(line: 1, column: 3, offset:2),
                end: Pos(line:1, column: 7, offset:6),
                type: "listText",
                value: "Test"),
            taurus.Token(
                    start: Pos(line: 1, column: 7, offset:6),
                    end: Pos(line:1, column: 7, offset:6),
                    type: "eof",
                    value: "")])
    }
    
    func testLinkSequenceWithoutText() throws {
        XCTAssertEqual(parseGemini()("=> gemini://macwright.com/", true), [
            taurus.Token(
                start: Pos(line: 1, column: 1, offset:0),
                end: Pos(line:1, column: 3, offset:2),
                type: "linkSequence",
                value: "=>"),
            taurus.Token(
                start: Pos(line: 1, column: 3, offset:2),
                end: Pos(line:1, column: 4, offset:3),
                type: "whitespace",
                value: " "),
            taurus.Token(
                start: Pos(line: 1, column: 4, offset:3),
                end: Pos(line:1, column: 27, offset:26),
                type: "linkUrl",
                value: "gemini://macwright.com/"),
            taurus.Token(
                start: Pos(line: 1, column: 27, offset:26),
                end: Pos(line:1, column: 27, offset:26),
                type: "eof",
                value: "")])
    }
    
    func testLinkSequence() throws {
        XCTAssertEqual(parseGemini()("=> gemini://macwright.com/ Click", true), [
            taurus.Token(
                start: Pos(line: 1, column: 1, offset:0),
                end: Pos(line:1, column: 3, offset:2),
                type: "linkSequence",
                value: "=>"),
            taurus.Token(
                start: Pos(line: 1, column: 3, offset:2),
                end: Pos(line:1, column: 4, offset:3),
                type: "whitespace",
                value: " "),
            taurus.Token(
                start: Pos(line: 1, column: 4, offset:3),
                end: Pos(line:1, column: 27, offset:26),
                type: "linkUrl",
                value: "gemini://macwright.com/"),
            taurus.Token(
                start: Pos(line: 1, column: 27, offset:26),
                end: Pos(line:1, column: 28, offset:27),
                type: "whitespace",
                value: " "),
            taurus.Token(
                start: Pos(line: 1, column: 28, offset:27),
                end: Pos(line:1, column: 33, offset:32),
                type: "linkText",
                value: "Click"),
            taurus.Token(
                start: Pos(line: 1, column: 33, offset:32),
                end: Pos(line:1, column: 33, offset:32),
                type: "eof",
                value: "")])
    }
    
    func testQuote() throws {
        XCTAssertEqual(parseGemini()("> Yes", true), [
            taurus.Token(
                start: Pos(line: 1, column: 1, offset:0),
                end: Pos(line:1, column: 2, offset:1),
                type: "quoteSequence",
                value: ">"),
            taurus.Token(
                start: Pos(line: 1, column: 2, offset:1),
                end: Pos(line:1, column: 3, offset:2),
                type: "whitespace",
                value: " "),
            taurus.Token(
                start: Pos(line: 1, column: 3, offset:2),
                end: Pos(line:1, column: 6, offset:5),
                type: "linkText",
                value: "Yes"),
            taurus.Token(
                start: Pos(line: 1, column: 6, offset:5),
                end: Pos(line:1, column: 6, offset:5),
                type: "eof",
                value: "")])
    }
    
    func testText() throws {
        XCTAssertEqual(parseGemini()("Yes", true), [
            taurus.Token(
                start: Pos(line: 1, column: 1, offset:0),
                end: Pos(line:1, column: 4, offset:3),
                type: "text",
                value: "Yes"),
            taurus.Token(
                start: Pos(line: 1, column: 4, offset:3),
                end: Pos(line:1, column: 4, offset:3),
                type: "eof",
                value: "")])
    }
}
