//
//  TextView.swift
//  taurus
//
//  Created by Tom MacWright on 1/15/21.
//

import SwiftUI

struct PreView: View {
    
    var value: String
    
    var body: some View {
        Text(value)
            .font(.system(.body, design: .monospaced))
            .lineSpacing(5.0)
            .foregroundColor(Color("Pre"))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 5.0)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct PreView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(value: "Test")
    }
}
