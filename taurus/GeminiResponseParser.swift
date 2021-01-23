//
//  GeminiHeaderParser.swift
//  taurus
//
//  Created by Tom MacWright on 1/23/21.
//

import Foundation

struct GeminiDocument: Equatable {
    var status: Int
    var mediaType: String
    var body: String
    var tree: Node
}

func parseResponse(content: String) -> GeminiDocument? {
    var bits = content.split(maxSplits: 1, whereSeparator: \.isNewline);
    if (bits.count != 2) {
    print("bits are null, content is \(content), count is \(bits.count)")
      return nil
    }
    let header = bits[0];
    let body = String(bits[1]);
    print("header: \(header)")
    print("body to parse: \(body)")
    var tree = compileGemini(tokens: parseGemini()(body, true));
    return GeminiDocument(status: 200, mediaType: "text/gemini", body: body, tree: tree)
}
