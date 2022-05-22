//
//  UrlShortenerViewModel.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/25/22.
//

import UIKit
import Combine

enum UrlShortenerViewModelError: Error, Equatable {
    case utlShortening
}

enum UrlShortenerViewModelState: Equatable {
    case none
    case loading
    case finishedLoading
    case error(UrlShortenerViewModelError)
}

final class UrlShortenerViewModel {
    
    @Published var fullUrl: String = ""
    @Published private(set) var shortUrl: ShortUrl?
    @Published private(set) var urlList: [ShortUrl] = []
    @Published private(set) var state: UrlShortenerViewModelState = .none
        
    private let urlShortenService: UrlShortenServiceProtocol
    private let dataStoreService: DataStoreServiceProtocol
    private var bindings = Set<AnyCancellable>()
    
    init(urlShortenService: UrlShortenServiceProtocol = UrlShortenApi(), dataStoreService: DataStoreServiceProtocol = DataStore()) {
        self.urlShortenService = urlShortenService
        self.dataStoreService = dataStoreService
    }

}

extension UrlShortenerViewModel {
    func urlShorten() {
        state = .loading
        let urlShortenCompletionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion
            in
            switch completion {
            case .failure:
                self?.state = .error(.utlShortening)
            case .finished:
                self?.state = .finishedLoading
            }
        }
        
        let urlShortenValueHandler: (ShortUrl) -> Void = { [weak self] shortUrl in
            self?.shortUrl = shortUrl
            self?.appendShortUrl(shortUrl: shortUrl)
        }
        
        urlShortenService
            .urlShorten(fullUrl: fullUrl)
            .sink(receiveCompletion: urlShortenCompletionHandler, receiveValue: urlShortenValueHandler)
            .store(in: &bindings)
    }
    
    func fetchUrlList() {
        let urlList = dataStoreService.fatchUrlList()
        self.urlList = urlList
    }
    
    func appendShortUrl(shortUrl: ShortUrl?) {
        _ = dataStoreService.appendShortUrl(shortUrl: shortUrl)
    }
    
    func deleteShortUrl(at index: Int) {
        _ = dataStoreService.deleteShortUrl(at: index)
    }
    
    func updateCopyStatus(at index: Int) {
        urlList.filter({$0.isSelected == true}).first?.isSelected = false
        let shortUrl = self.urlList[index]
        shortUrl.isSelected = true
    }
    
    func copyToClipboard(shortUrl: ShortUrl?) {
        ClipboardUtils.copyToClipboard(shortUrl: shortUrl)
    }
    
    func isUrlExists(urlStr: String) -> Bool
    {
        return dataStoreService.isUrlExists(urlStr: urlStr)
    }
}
