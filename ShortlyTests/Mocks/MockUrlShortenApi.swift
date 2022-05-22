//
//  MockUrlShortenApi.swift
//  ShortlyTests
//
//  Created by Abdullah Muhammad Zubair on 3/3/22.
//

import Foundation
import Combine
@testable import Shortly

class MockUrlShortenApi: UrlShortenServiceProtocol {
    var getArguments: [String?] = []
    var getCallsCount: Int = 0
    
    var getResult: Result<ShortUrl, Error> = .success(ShortUrl(code: "", short_link: "", full_short_link: "", short_link2: "", full_short_link2: "", share_link: "", full_share_link: "", original_link: ""))

    func urlShorten(fullUrl: String?) -> AnyPublisher<ShortUrl, Error> {
        getArguments.append(fullUrl)
        getCallsCount += 1
        
        return getResult.publisher.eraseToAnyPublisher()

    }

}
