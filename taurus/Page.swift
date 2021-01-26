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
    @Published var url: URL? = nil
    @Published var status: PageStatus = PageStatus.none;
    @Published var document: GeminiDocument? = nil;
    @Published var source: String = ""
    
    init(url: URL?, status: PageStatus, document: GeminiDocument?, source: String) {
        self.url = url
        self.status = status
        self.document = document
        self.source = source
    }
}
