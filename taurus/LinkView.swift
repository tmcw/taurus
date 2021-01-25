//
//  TextView.swift
//  taurus
//
//  Created by Tom MacWright on 1/15/21.
//

import SwiftUI

struct LinkView: View {
    
    var value: String
    let navigate: () -> Void
    @State private var hovered = false
    
    var body: some View {
        Button(action: {
            self.navigate();
        }) {
          Text(value)
            .font(.system(size: 18))
              .underline(hovered)
              .lineSpacing(5.0)
              .foregroundColor(Color("Link"))
              .multilineTextAlignment(.leading)
              .padding(.vertical, 5.0)
              .padding(.horizontal, 20.0)
              .lineLimit(nil)
              .onHover { isHovered in
                  self.hovered = isHovered
              }
        }
          .buttonStyle(LinkButtonStyle())
          .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
          LinkView(value: "Test") {
              print("Clicked");
          }
          LinkView(value: String(repeating: "Long link goes… ", count: 10)) {
              print("Clicked");
          }
        }.frame(maxWidth: 400.0)
    }
}
