//
//  ShortUrl.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/24/22.
//

import Foundation

class ShortUrl: Codable {
    var code: String?
    var short_link: String?
    var full_short_link: String?
    var short_link2: String?
    var full_short_link2: String?
    var share_link: String?
    var full_share_link: String?
    var original_link: String?
    var isSelected = false
    
    init(code: String?, short_link: String?, full_short_link: String?, short_link2: String?, full_short_link2: String?, share_link: String?, full_share_link: String?, original_link: String?) {
        self.code = code
        self.short_link = short_link
        self.full_short_link = full_short_link
        self.short_link2 = short_link2
        self.full_short_link2 = full_short_link2
        self.share_link = share_link
        self.full_share_link = full_short_link
        self.original_link = original_link
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum CodingKeys: String, CodingKey {
        case code
        case short_link
        case full_short_link
        case short_link2
        case full_short_link2
        case share_link
        case full_share_link
        case original_link
    }
    
}

extension ShortUrl: Hashable {
    static func ==(lhs: ShortUrl, rhs: ShortUrl) -> Bool {
        return lhs.code == rhs.code || lhs.isSelected == rhs.isSelected
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
        hasher.combine(isSelected)
    }
}
