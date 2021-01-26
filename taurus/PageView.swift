//
//  PageView.swift
//  taurus
//
//  Created by Tom MacWright on 1/25/21.
//

import SwiftUI

struct PageView: View {
    @ObservedObject var page: Page
    let navigate: (String) -> Void
    
    var body: some View {
        ScrollView(.vertical) {
            Group {
                VStack(alignment: .leading) {
                    if let document = page.document {
                        ForEach(document.tree.children, id: \.self) { node in
                            switch node.data {
                            case Data.root:
                                EmptyView()
                            case Data.brk:
                                EmptyView()
                            case let .listItem(value):
                                ListItemView(value: value)
                            case let .text(value):
                                TextView(value: value)
                            case let .heading(value, rank):
                                HeadingView(value: value, rank: rank)
                            case let .quote(value):
                                QuoteView(value: value)
                            case let .pre(value, _):
                                PreView(value: value)
                            case let .webLink(value, url):
                                WebLinkView(value: value, url: url)
                            case let .link(value, url):
                                LinkView(value: value) {
                                    print("Navigating to \(url), relative to \(page.url)")
                                    let u = URL(string: "\(url)", relativeTo: URL(string: page.url))!
                                    navigate("\(u.absoluteURL)")
                                }
                            }
                        }
                    } else {
                        Text("Loading…")
                    }
                }.frame(minWidth: 200.0, idealWidth: 640.0, maxWidth: 800.0).padding(.bottom, 100.0).padding(.top, 50.0)
            }.frame(maxWidth: .infinity)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        var page = Page(
            url: "gemini://fake.com",
            status: PageStatus.loaded,
            document: parseResponse(content: "text/gemini\rTest"))
        PageView(page: page, navigate: {_ in })
    }
}
