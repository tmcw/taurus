//
//  NavigationView.swift
//  taurus
//
//  Created by Tom MacWright on 1/25/21.
//

import SwiftUI

struct NavigationView: View {
    // TODO: state management
    @State private var inputUrl: String = "gemini://drewdevault.com"

    func loadUrl() {
        // TODO: implement
    }

    func go() {}

    var body: some View {
        HStack {
            Button(action: go) {
                if #available(OSX 11.0, *) {
                    Image(systemName: "chevron.left")
                } else {
                    // Fallback on earlier versions
                }

            }.buttonStyle(PlainButtonStyle())
            Button(action: go) { if #available(OSX 11.0, *) {
                Image(systemName: "chevron.right")
            } else {
                // Fallback on earlier versions
            }
            }.buttonStyle(PlainButtonStyle())
            TextField("URL", text: $inputUrl, onCommit: loadUrl)
                .padding(10.0)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(Color("Foreground"))
                .background(Color("AccentBackground").cornerRadius(5.0))
            Button(action: go) {
                if #available(OSX 11.0, *) {
                    Image(systemName: "chevron.forward.square")
                } else {
                    // Fallback on earlier versions
                }
            }.buttonStyle(PlainButtonStyle())
        }.padding(10.0)
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
