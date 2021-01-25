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
        Group {
          ScrollView(.horizontal) {
            Text(value)
              .font(.system(.body, design: .monospaced))
              .lineSpacing(5.0)
              .foregroundColor(Color("Pre"))
              .multilineTextAlignment(.leading)
              .padding(.horizontal, 20.0)
              .padding(.vertical, 20.0)
              .frame(maxWidth: .infinity, alignment: .topLeading)
              .background(Color("PreBackground").cornerRadius(5.0))
          }
        }.padding(.horizontal, 20.0).padding(.vertical, 20.0)
    }
}

struct PreView_Previews: PreviewProvider {
    static var previews: some View {
        PreView(value: """
function x(y) {
  let x = "long Line that should not wrap because this is a preformatted element";
  return y + 1;
}
""")
    }
}
