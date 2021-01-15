//
//  GeminiParser.swift
//  taurus
//
//  Created by Tom MacWright on 1/8/21.
//

import Foundation

struct Pos: Equatable {
    var line = 0
    var column = 0
    var offset = 0
}

struct Token: Equatable {
    var start: Pos
    var end: Pos
    var type: String
    var value: String
    var hard: Bool? = nil
}

func ws(code: UInt8?) -> Bool {
    return code == 9 /* `\t` */ || code == 32 /* ` ` */
}

func parseGemini() -> (String, Bool) -> [Token] {
    var values: [Substring] = []
    var line = 1
    var column = 1
    var offset = 0
    var preformatted: Bool = false
    
    func now() -> Pos {
        return Pos(line: line, column: column, offset: offset)
    }
    
    func parse(buffer: String, done: Bool) -> [Token] {
        
        var start: String.Index = buffer.startIndex
        var results: [Token] = []
        var value: String
        var eol: String
        
        func add(type: String, value: Substring, hard: Bool? = nil) {
            let start = now()
            
            offset += value.count
            column += value.count
            
            // Note that only a final line feed is supported: it’s assumed that
            // they’ve been split over separate tokens already.
            if (value.last?.asciiValue == 10 /* `\n` */) {
                line += 1
                column = 1
            }
            
            let end = now()
            
            let token = Token(start: start, end: end, type: type, value: String(value), hard: hard)
            
            results.append(token)
        }
        

        
        func parseLine(value: String) {
            let code = value.first?.asciiValue
            var index: String.Index = value.startIndex
            var start: String.Index
            
            func codeAtOffset(offset: Int) -> UInt8? {
                return value[value.index(value.startIndex, offsetBy: offset)].asciiValue;
            }
            
            if (
                code == 96 /* `` ` `` */ &&
                    codeAtOffset(offset: 1) == 96 /* `` ` `` */ &&
                    codeAtOffset(offset: 2) == 96 /* `` ` `` */
            ) {
                add(type: "preSequence", value: value[..<value.index(index, offsetBy: 3)])
                if (value.count != 3) {
                    add(type: "preAlt", value: value[value.index(value.startIndex, offsetBy: 3)..<value.endIndex])
                }
                preformatted = !preformatted
            }
            // Pre text.
            else if (preformatted) {
                if (value != "") {
                    add(type: "preText", value: Substring(value))
                }
            }
            // Heading.
            else if (code == 35 /* `#` */) {
                index = value.index(value.startIndex, offsetBy: 1)
                var headerLevel: Int = 1
                while (headerLevel < 3 && index < value.endIndex && value[index].asciiValue == 35 /* `#` */) {
                    index = value.index(index, offsetBy: 1)
                    headerLevel += 1
                }
                add(type: "headingSequence", value: value[value.startIndex..<index])
                
                // Optional whitespace.
                start = index
                while (index < value.endIndex && ws(code: value[index].asciiValue)) {
                    index = value.index(index, offsetBy: 1)
                }
                if (start != index) {
                    add(type: "whitespace", value: value[start..<index])
                }
                
                // Optional heading text.
                if (index != value.endIndex) {
                    add(type: "headingText", value: value[index..<value.endIndex])
                }
            }
            // List.
            else if (
                code == 42 /* `*` */ &&
                    (value.count == 1 || ws(code: codeAtOffset(offset: 1)))
            ) {
                add(type: "listSequence", value: "*")
                
                // Optional whitespace.
                index = value.index(value.startIndex, offsetBy: 1)
                let startOfContent = index
                while (index < value.endIndex && ws(code: value[index].asciiValue)) {
                    index = value.index(index, offsetBy: 1)
                }
                if (index != startOfContent) {
                    add(type: "whitespace", value: value[startOfContent..<index])
                }
                
                // Optional list text.
                if (index != value.endIndex) {
                    add(type: "listText", value: value[index..<value.endIndex])
                }
            }
            
            // Link
            else if (code == 61 /* `=` */ && codeAtOffset(offset: 1) == 62 /* `>` */) {
                add(type: "linkSequence", value: value[value.startIndex..<value.index(value.startIndex, offsetBy: 2)])
                
                // Optional whitespace.
                index = value.index(value.startIndex, offsetBy: 2)
                start = index
                while (ws(code: value[index].asciiValue)) {
                    index = value.index(index, offsetBy: 1)
                }
                if (index != start) {
                    add(type: "whitespace", value: value[start..<index])
                }
                
                // Optional non-whitespace is the URL.
                start = index
                while (index != value.endIndex && !ws(code: value[index].asciiValue)) {
                    index = value.index(index, offsetBy: 1)
                }
                if (index > start) {
                    add(type: "linkUrl", value: value[start..<index])
                }
                
                if (index < value.endIndex) {
                  // Optional whitespace.
                  start = index
                  while (ws(code: value[index].asciiValue) && index < value.endIndex) {
                      index = value.index(index, offsetBy: 1)
                  }
                  if (index != start) {
                      add(type: "whitespace", value: value[start..<index])
                  }
                  
                  // Rest is optional link text.
                  if (index != value.endIndex) {
                      add(type: "linkText", value: value[index..<value.endIndex])
                  }
                }
            }
            // Block quote.
            else if (code == 62 /* `>` */) {
                index = value.index(value.startIndex, offsetBy: 1)
                add(type: "quoteSequence", value: value[value.startIndex..<index])
                
                // Optional whitespace.
                start = index
                while (index < value.endIndex && ws(code: value[index].asciiValue)) {
                    index = value.index(index, offsetBy: 1)
                }
                if (index != start) {
                    add(type: "whitespace", value: value[start..<index])
                }
                
                if (index != value.endIndex) {
                    add(type: "quoteText", value: value[index..<value.endIndex])
                }
            }
            else if (value.count != 0) {
                add(type: "text", value: Substring(value))
            }
        }
        
        var end = buffer.firstIndex(of: "\n")
        print("buffer:")
        print(buffer)
        
        while (end != nil) {
            value = values.joined(separator: "") + buffer[start..<end!]
            values = []
            
            if (value.last?.asciiValue == 13 /* `\r` */) {
                _ = value.popLast()
                eol = "\r\n"
            } else {
                eol = "\n"
            }
            
            print("Parsing line:")
            print(value)
            parseLine(value: value)
            add(type: "eol", value: Substring(eol)/*, {hard: !preformatted && !value.count}*/)
            
            start = buffer.index(end!, offsetBy: 1)
            print("next line")
            print(buffer[start..<buffer.endIndex])
            // TODO: This is where I'm leaving off, and it's a hard one. String.Index
            // and String.IndexDistance are not working well here.
            end = buffer[start..<buffer.endIndex].firstIndex(of: "\n");
        }
        
        if (buffer != "") {
            print("last line:")
            print(buffer[start..<buffer.endIndex])
            values.append(buffer[start..<buffer.endIndex])
        }
        
        if (done) {
            print(values.joined(separator: ""))
            parseLine(value: values.joined(separator: ""))
            add(type: "eof", value: Substring(""))
        }
        
        return results
    }
    
    return parse;
}

