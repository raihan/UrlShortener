//
//  ShortUrlCellViewModel.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/28/22.
//

import Foundation

class ShortUrlCellViewModel {
    @Published var shortLink: String = ""
    @Published var fullUrl: String = ""
    @Published var isSelected: Bool = false
    
    private let shortUrl: ShortUrl
    
    init(shortUrl: ShortUrl) {
        self.shortUrl = shortUrl
        setUpBindings()
    }
    
    private func setUpBindings() {
        shortLink = shortUrl.full_short_link2 ?? ""
        fullUrl = shortUrl.original_link ?? ""
        isSelected = shortUrl.isSelected 
    }
}
