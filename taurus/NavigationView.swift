//
//  NavigationView.swift
//  taurus
//
//  Created by Tom MacWright on 1/25/21.
//

import SwiftUI

struct NavigationView: View {
    @Binding var inputUrl: String
    let onGo: () -> Void
    let save: () -> Void

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
            
            TextField("URL", text: $inputUrl, onCommit: onGo)
                .padding(10.0)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(Color("Foreground"))
                .background(Color("AccentBackground").cornerRadius(5.0))
                
            if #available(OSX 11.0, *) {
                Button(action: save) {
                    Image(systemName: "square.and.arrow.down")
                }.buttonStyle(PlainButtonStyle())
                .keyboardShortcut("S", modifiers: [.command])
            } else {
                // Fallback on earlier versions
            }
        }.padding(10.0)
    }
}

struct NavigationView_Previews: PreviewProvider {
    @State static var inputUrl = "gemini://foo.com"
    static var previews: some View {
        NavigationView(inputUrl: $inputUrl, onGo: {}, save: {})
    }
}
