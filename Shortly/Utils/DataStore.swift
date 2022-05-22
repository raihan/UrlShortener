//
//  DataStore.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/28/22.
//

import Foundation

protocol DataStoreServiceProtocol {
    func fatchUrlList() -> [ShortUrl]
    func saveUrlList(urlList: [ShortUrl]) -> Bool
    func appendShortUrl(shortUrl: ShortUrl?) -> [ShortUrl]
    func deleteShortUrl(shortUrl: ShortUrl?) -> [ShortUrl]
    func deleteShortUrl(at index: Int) -> [ShortUrl]
    func isUrlExists(urlStr: String) -> Bool
}

class DataStore: DataStoreServiceProtocol {
    private let key = "urlList"

    func fatchUrlList() -> [ShortUrl] {
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode url list
                return try decoder.decode([ShortUrl].self, from: data)
            } catch {
                print("Unable to Decode url list (\(error))")
            }
        }
        return []
    }
    
    func saveUrlList(urlList: [ShortUrl]) -> Bool {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode url list
            let data = try encoder.encode(urlList)
            UserDefaults.standard.set(data, forKey: key)
            return true

        } catch {
            print("Unable to Encode Array of urlList (\(error))")
            return false
        }
    }
    
    func appendShortUrl(shortUrl: ShortUrl?) -> [ShortUrl] {
        guard let shortUrl = shortUrl else {
            return []
        }
        var urlList = fatchUrlList()
        urlList.append(shortUrl)
        _ = saveUrlList(urlList: urlList)
        return urlList
    }
    
    func deleteShortUrl(shortUrl: ShortUrl?) -> [ShortUrl] {
        guard let shortUrl = shortUrl else {
            return []
        }
        var urlList = fatchUrlList()
        urlList = urlList.filter { $0.code != shortUrl.code }
        _ = saveUrlList(urlList: urlList)
        return urlList
    }
    
    func deleteShortUrl(at index: Int) -> [ShortUrl] {
        var urlList = fatchUrlList()
        urlList.remove(at: index)
        _ = saveUrlList(urlList: urlList)
        return urlList
    }
    
    func isUrlExists(urlStr: String) -> Bool {
        let urlList = fatchUrlList()
        for url in  urlList {
            if url.original_link == urlStr
            {
                return true
            }
        }
        return false
    }
}
