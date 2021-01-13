//
//  GeminiCompiler.swift
//  taurus
//
//  Created by Tom MacWright on 1/13/21.
//

import Foundation

struct Position: Equatable {
    var start: Pos;
    var end: Pos? = nil;
}

struct Node: Equatable {
    var type: String;
    var value: String? = nil;
    var children: [Node] = [];
    var position: Position;
    var alt: String? = nil;
    var url: String? = nil;
    var rank: Int? = nil;
}

func compileGemini(tokens: [Token]) -> Node {
    func point(d: Pos) -> Pos {
        // TODO: just clone?
        return Pos(line: d.line, column: d.column, offset: d.offset)
    }
    var stack: [Node] = [
        Node(
            type: "root",
            children: [],
            position: Position(
                start: point(d: tokens[0].start),
                end: point(d: tokens[tokens.count - 1].end)
            )
        )
    ]
    var index = 0
    var token: Token
    var node: Node
    var values: [String]
    
    func enter(type: String, value: String? = nil, rank: Int? = nil, children: [Node] = [], token: Token) -> Node {
        var node = Node(
            type: type,
            value: value,
            children: children,
            position: Position(start: point(d: token.start)),
            rank: rank
        )
        stack[stack.endIndex - 1].children.append(node)
        stack.append(node)
        return node
    }
    
    func exit(token: Token) -> Node {
        var node = stack.removeLast()
        node.position.end = point(d: token.end)
        return node
    }

    while (index < tokens.count - 1) {
        token = tokens[index]
        
        if (token.type == "eol" && token.hard != nil) {
            _ = enter(type: "break", token: token)
            _ = exit(token: token)
        } else if (token.type == "headingSequence") {
            
            if (tokens[index + 1].type == "whitespace") {
                index += 1
            }
            if (tokens[index + 1].type == "headingText") {
                index += 1
                node = enter(
                    type: "heading",
                    value: tokens[index].value,
                    rank: token.value.count,
                    token: token
                )
            } else {
                node = enter(
                    type: "heading", value: "", rank: token.value.count,
                    token: token
                )
            }
            
            _ = exit(token: tokens[index])
        } else if (token.type == "linkSequence") {
            node = enter(type: "link", value: "", token: token)
            
            if (tokens[index + 1].type == "whitespace") {
                index += 1
            }
            if (tokens[index + 1].type == "linkUrl") {
                index += 1
                node.url = tokens[index].value
                
                if (tokens[index + 1].type == "whitespace") {
                    index += 1
                }
                if (tokens[index + 1].type == "linkText") {
                    index += 1
                    node.value = tokens[index].value
                }
            }
            
            _ = exit(token: tokens[index])
        } else if (token.type == "listSequence") {
            if (stack[stack.count - 1].type != "list") {
                _ = enter(type: "list", children: [], token: token)
            }
            
            
            if (tokens[index + 1].type == "whitespace") {
                index += 1
            }
            if (tokens[index + 1].type == "listText") {
                index += 1
                node = enter(type: "listItem", value: tokens[index].value, token: token)
            } else {
                node = enter(type: "listItem", value: "", token: token)
            }
            
            _ = exit(token: tokens[index])
            
            if (
                tokens[index + 1].type != "eol" ||
                    tokens[index + 2].type != "listSequence"
            ) {
                _ = exit(token: tokens[index])
            }
        } else if (token.type == "preSequence") {
            node = enter(type: "pre", value: "", token: token)
            values = []
            
            if (tokens[index + 1].type == "preAlt") {
                index += 1
                node.alt = tokens[index].value
            }
            
            // Slurp the first EOL.
            if (tokens[index + 1].type == "eol") {
                index += 1
            }
            
            while (index < tokens.count - 1) {
                if (tokens[index].type == "eol" || tokens[index].type == "preText") {
                    values.append(tokens[index].value)
                } else {
                    // This can only be the closing `preSequence` or and `EOF`.
                    // In the case of the former, there was an EOL, which we remove.
                    if (tokens[index].type == "preSequence") {
                        values.removeLast()
                        
                        // Move past an (ignored) closing alt.
                        if (tokens[index + 1].type == "preAlt") {
                            index += 1
                        }
                    }
                    
                    break
                }
                index += 1
            }
            
            node.value = values.joined(separator: "")
            
            _ = exit(token: tokens[index])
        } else if (token.type == "quoteSequence") {
            
            if (tokens[index + 1].type == "whitespace") {
                index += 1
            }
            if (tokens[index + 1].type == "quoteText") {
                index += 1
                node = enter(type: "quote", value: tokens[index].value, token: token)
            } else {
                node = enter(type: "quote", value: "", token: token)
            }
            
            _ = exit(token: tokens[index])
        } else if (token.type == "text") {
            _ = enter(type: "text", value: token.value, token: token)
            _ = exit(token: token)
        }
        // Else would be only soft EOLs and EOF.
        index += 1
    }
    
    return stack[0]
}
