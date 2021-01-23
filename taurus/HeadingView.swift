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
            return Font.title;
          case 2:
            if #available(OSX 11.0, *) {
                return Font.title2
            } else {
                return Font.subheadline;
            };
          default:
            if #available(OSX 11.0, *) {
                return Font.title3
            } else {
                return Font.subheadline;
            };
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
        TextView(value: "Test")
    }
}
