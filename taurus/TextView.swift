//
//  TextView.swift
//  taurus
//
//  Created by Tom MacWright on 1/15/21.
//

import SwiftUI

struct TextView: View {
    
    var value: String
    
    var body: some View {
        Text(value)
            .font(.custom("Georgia", size: 20))
            .lineSpacing(10.0)
            .foregroundColor(Color("Foreground"))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 5.0)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(value: """
Test, this is a paragraph of preview text. In Gemini, this might be a paragraph. But it should at least be long enough to wrap.
"""
        )
    }
}
