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
          .font(.custom("Georgia", size: 18))
          .lineSpacing(5.0)
          .foregroundColor(Color("Foreground"))
          .multilineTextAlignment(.leading)
          .padding(.leading, 40.0)
          .padding(.trailing, 20.0)
          .padding(.vertical, 15.0)
          .lineLimit(nil)
          .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(value: "Test")
    }
}
