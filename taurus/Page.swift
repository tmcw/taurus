//
//  Page.swift
//  taurus
//
//  Created by Tom MacWright on 1/25/21.
//

import Foundation

enum PageStatus: Equatable, Hashable {
    case none
    case loading
    case loaded
}

class Page: ObservableObject {
    @Published var url = ""
    @Published var status: PageStatus = PageStatus.none;
    @Published var document: GeminiDocument? = nil;
    
    init(url: String, status: PageStatus, document: GeminiDocument?) {
        self.url = url
        self.status = status
        self.document = document
    }
}
