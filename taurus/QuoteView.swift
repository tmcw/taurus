//
//  TextView.swift
//  taurus
//
//  Created by Tom MacWright on 1/15/21.
//

import SwiftUI

struct QuoteView: View {
    
    var value: String
    
    var body: some View {
        Text(value)
            .font(.system(.body, design: .monospaced))
            .lineSpacing(5.0)
            .foregroundColor(Color.white)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 5.0)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(value: "Test")
    }
}
