//
//  GeminiCompiler.swift
//  taurus
//
//  Created by Tom MacWright on 1/13/21.
//

import Foundation

struct Position: Equatable {
    var start: Pos;
    var end: Pos;
    init(start: Pos, end: Pos) {
        self.start = start
        self.end = end
    }
    init(fromToken t: Token) {
        start = t.start
        end = t.end
    }
}

enum Data: Equatable {
    case root
    case list
    case brk
    case listItem(value: String)
    case text(value: String)
    case heading(value: String, rank: Int)
    case quote(value: String)
    case pre(value: String, alt: String?)
    case link(value: String, url: String)
}

struct Node: Equatable {
    var data: Data;
    var position: Position
    var children: [Node] = [];
}

func compileGemini(tokens: [Token]) -> Node {
    let rootPosition = Position(
        start: tokens[0].start,
        end: tokens[tokens.count - 1].end
    )
    var rootNode: Node = Node(
        data: Data.root,
        position: rootPosition,
        children: []
    );
    var stack: [Node] = [
      rootNode
    ];
    var index = 0
    var token: Token
    var node: Node
    var values: [String]
    
    func addNode(node: Node) {
        stack[stack.count - 1].children.append(node);
    }

    while (index < tokens.count - 1) {
        token = tokens[index]
        
        if (token.type == "eol" && token.hard != nil) {
            addNode(node: Node(data: Data.brk, position: Position(fromToken: token)))
        } else if (token.type == "headingSequence") {
            if (tokens[index + 1].type == "whitespace") {
                index += 1
            }
            if (tokens[index + 1].type == "headingText") {
                index += 1
                addNode(node: Node(data: Data.heading(value: tokens[index].value, rank: token.value.count), position: Position(fromToken: token)))
            } else {
                addNode(node: Node(data: Data.heading(value: "", rank: token.value.count), position: Position(fromToken: token)))
            }
        } else if (token.type == "linkSequence") {
            var value = ""
            var url = ""
            
            if (tokens[index + 1].type == "whitespace") {
                index += 1
            }
            if (tokens[index + 1].type == "linkUrl") {
                index += 1
                url = tokens[index].value
                
                if (tokens[index + 1].type == "whitespace") {
                    index += 1
                }
                if (tokens[index + 1].type == "linkText") {
                    index += 1
                    value = tokens[index].value
                }
            }
            
            addNode(node: Node(data: Data.link(value: value, url: url), position: Position(fromToken: token)))
        } /* else if (token.type == "listSequence") {
            if (stack[stack.count - 1] is ListNode) {
                enterNode(node: ListNode(position: Position(start: token.start))
            }
            
            if (tokens[index + 1].type == "whitespace") {
                index += 1
            }
            if (tokens[index + 1].type == "listText") {
                index += 1
                node = enterNode(node: ListItemNode(value: tokens[index].value, position: Position(fromToken: token)))
            } else {
                node = enterNode(node: ListItemNode(value: "", position: Position(fromToken: token.start)))
            }
            
            if (
                tokens[index + 1].type != "eol" ||
                    tokens[index + 2].type != "listSequence"
            ) {
                _ = exit(token: tokens[index])
            }
        } */ else if (token.type == "preSequence") {
            values = []
            var alt: String? = nil
            
            if (tokens[index + 1].type == "preAlt") {
                index += 1
                alt = tokens[index].value
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
            
            
            addNode(node: Node(data: Data.pre(value: values.joined(separator: ""),
                                           alt: alt),
                                           position: Position(fromToken: token)))
            
        } else if (token.type == "quoteSequence") {
            if (tokens[index + 1].type == "whitespace") {
                index += 1
            }
            if (tokens[index + 1].type == "quoteText") {
                index += 1
                addNode(node: Node(data: Data.quote(value: tokens[index].value), position: Position(fromToken: token)))
            } else {
                addNode(node: Node(data: Data.quote(value: ""), position: Position(fromToken: token)))
            }
        } else if (token.type == "text") {
            addNode(node: Node(data: Data.text(value: token.value), position: Position(fromToken: token)))
        }
        // Else would be only soft EOLs and EOF.
        index += 1
    }
    
    return stack.first!;
}
