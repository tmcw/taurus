//
//  TextView.swift
//  taurus
//
//  Created by Tom MacWright on 1/15/21.
//

import SwiftUI

struct LinkView: View {
    
    var value: String
    
    var body: some View {
        Text(value)
            .font(.body)
            .lineSpacing(0.0)
            .foregroundColor(Color("Link"))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 2.0)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(value: "Test")
    }
}
