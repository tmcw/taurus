//
//  TextView.swift
//  taurus
//
//  Created by Tom MacWright on 1/15/21.
//

import SwiftUI

struct HeadingView: View {
    
    var value: String
    var rank: Int
    
    func font() -> Font {
      switch (rank) {
          case 1:
            return Font.system(size: 24).weight(.heavy);
          case 2:
            return Font.system(size: 20).weight(.heavy);
          default:
            return Font.system(size: 18).weight(.heavy);
      }
    }
    
    var body: some View {
        Text(value)
            .font(font())
            .lineSpacing(5.0)
            .foregroundColor(Color("Heading"))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 20.0)
            .padding(.vertical, 5.0)
            .lineLimit(nil)
            .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct HeadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
          HeadingView(value: "Heading 1", rank: 1)
          HeadingView(value: "Heading 2", rank: 2)
          HeadingView(value: "Heading 3", rank: 3)
        }
    }
}
