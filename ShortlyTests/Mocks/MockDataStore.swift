//
//  MockDataStore.swift
//  ShortlyTests
//
//  Created by Abdullah Muhammad Zubair on 3/3/22.
//

import Foundation
@testable import Shortly

class MockDataStore: DataStoreServiceProtocol {
    
    var urlList = [ShortUrl(code: "", short_link: "", full_short_link: "", short_link2: "", full_short_link2: "", share_link: "", full_share_link: "", original_link: "")]
    
    func fatchUrlList() -> [ShortUrl] {
        return urlList
    }
    
    func saveUrlList(urlList: [ShortUrl]) -> Bool {
        return true
    }
    func appendShortUrl(shortUrl: ShortUrl?) -> [ShortUrl] {
        urlList.append(shortUrl!)
        return urlList
    }
    
    func deleteShortUrl(shortUrl: ShortUrl?) -> [ShortUrl] {
        urlList = urlList.filter { $0.code != shortUrl?.code }
        return urlList
    }
    
    func deleteShortUrl(at index: Int) -> [ShortUrl] {
        urlList.remove(at: index)
        return urlList
    }
}
