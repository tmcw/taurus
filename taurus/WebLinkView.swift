//
//  TextView.swift
//  taurus
//
//  Created by Tom MacWright on 1/15/21.
//

import SwiftUI

struct WebLinkView: View {
    
    var value: String
    var url: String
    @State private var hovered = false
    
    var body: some View {

        if #available(OSX 11.0, *) {
            Link(value, destination: URL(string: url)!)
                .font(.system(size: 18))
                .lineSpacing(5.0)
                .foregroundColor(Color("WebLink"))
                .multilineTextAlignment(.leading)
                .padding(.vertical, 5.0)
                .padding(.horizontal, 20.0)
                .lineLimit(nil)
                .onHover { isHovered in
                    self.hovered = isHovered
                }
                .buttonStyle(LinkButtonStyle())
                .frame(maxWidth: .infinity, alignment: .topLeading)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct WebLinkView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
           WebLinkView(value: "Test", url: "https://google.com/")
        }.frame(maxWidth: 400.0)
    }
}
