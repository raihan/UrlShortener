//
//  ClipboardUtils.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 3/2/22.
//

import UIKit

enum ClipboardUtils {
    static func copyToClipboard(shortUrl: ShortUrl?)
    {
        guard let shortUrl = shortUrl else {
            return
        }
        UIPasteboard.general.string = shortUrl.short_link
    }
    
    static func getTextFromClipboard() -> String {
        return UIPasteboard.general.string ?? ""
    }
}
