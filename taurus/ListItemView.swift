//
//  TextView.swift
//  taurus
//
//  Created by Tom MacWright on 1/15/21.
//

import SwiftUI

struct ListItemView: View {
    
    var value: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 5.0) {
          Text("•")
            .font(.custom("Georgia", size: 20))
          Text(value)
              .font(.custom("Georgia", size: 20))
              .lineSpacing(5.0)
              .foregroundColor(Color("Foreground"))
              .multilineTextAlignment(.leading)
              .padding(.horizontal, 5.0)
              .padding(.vertical, 5.0)
              .lineLimit(nil)
              .frame(maxWidth: .infinity, alignment: .topLeading)
        }.padding(.horizontal, 20.0)
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(value: "I am a list item that can occupy multiple lines and thus will warp eveyt")
    }
}
