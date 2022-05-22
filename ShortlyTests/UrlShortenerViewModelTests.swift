//
//  UrlShortenerViewModelTests.swift
//  ShortlyTests
//
//  Created by Abdullah Muhammad Zubair on 2/23/22.
//

import XCTest
import Combine
@testable import Shortly

class UrlShortenerViewModelTests: XCTestCase {

    private var subject: UrlShortenerViewModel?
    private var mockUrlShortenService: MockUrlShortenApi?
    private var mockDataStoreService: MockDataStore?
    private var cancellables: Set<AnyCancellable> = []

    
    override func setUp() {
        super.setUp()

        mockUrlShortenService = MockUrlShortenApi()
        mockDataStoreService = MockDataStore()
        subject = UrlShortenerViewModel(urlShortenService: mockUrlShortenService!, dataStoreService: mockDataStoreService!)
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        mockUrlShortenService = nil
        subject = nil

        super.tearDown()
    }

    func test_shortenUrl_shouldCallService() {
        //given
        subject?.fullUrl = "http://a.com"
        // when
        subject?.urlShorten()

        // then
        XCTAssertEqual(mockUrlShortenService?.getCallsCount, 1)
        XCTAssertEqual(mockUrlShortenService?.getArguments.first, "http://a.com")
    }

    func test_shortenUrl_givenServiceCallSucceeds_shouldUpdateShortenUrl() {
        // given
        mockUrlShortenService?.getResult = .success(Constants.shortUrl)
        subject?.fullUrl = "http://a.com"

        // when
        subject?.urlShorten()

        // then
        XCTAssertEqual(mockUrlShortenService?.getCallsCount, 1)
        XCTAssertEqual(mockUrlShortenService?.getArguments.last, "http://a.com")
        subject?.$shortUrl
            .sink { XCTAssertEqual($0, Constants.shortUrl) }
            .store(in: &cancellables)

        subject?.$state
            .sink { XCTAssertEqual($0, .finishedLoading) }
            .store(in: &cancellables)
    }
    
    func test_shortenUrl_givenServiceCallFails_shouldUpdateStateWithError() {
        // given
        mockUrlShortenService?.getResult = .failure(MockError.error)
        subject?.fullUrl = "http://a.com"

        // when
        subject?.urlShorten()

        // then
        XCTAssertEqual(mockUrlShortenService?.getCallsCount, 1)
        XCTAssertEqual(mockUrlShortenService?.getArguments.last, "http://a.com")
        subject?.$shortUrl
            .sink { XCTAssert($0 == nil) }
            .store(in: &cancellables)

        subject?.$state
            .sink { XCTAssertEqual($0, .error(.utlShortening)) }
            .store(in: &cancellables)
    }
    
    func test_fetchUrlList() {
        //when
        subject?.fetchUrlList()
        
        //then
        XCTAssertTrue(mockDataStoreService?.fatchUrlList().count ?? 0 > 0)
    }
    
    func test_appendShortUrl() {
        //when
        subject?.appendShortUrl(shortUrl: Constants.shortUrl)
        
        //then
        let urlList = mockDataStoreService?.fatchUrlList().filter { $0.code == Constants.shortUrl.code }
        XCTAssertTrue(urlList?.count ?? 0 > 0)
    }
    
    func test_deleteShortUrl() {
        //given
        subject?.appendShortUrl(shortUrl: Constants.shortUrl)
        let count = mockDataStoreService?.urlList.count ?? 0
        
        //when
        subject?.deleteShortUrl(at: 0)
        
        //then
        XCTAssertTrue(mockDataStoreService?.urlList.count == count - 1)
    }

    func test_updateCopyStatus() {
        //given
        subject?.fetchUrlList()
        subject?.appendShortUrl(shortUrl: Constants.shortUrl)
        
        //when
        subject?.updateCopyStatus(at: 0)
        let shortUrl = mockDataStoreService?.urlList.first!
        XCTAssertTrue(shortUrl?.isSelected ?? false)
    }
}

// MARK: - Helpers

extension UrlShortenerViewModelTests {
    enum Constants {
        static let shortUrl = ShortUrl(code: "abc",
                                       short_link: "https://a.com",
                                       full_short_link: "https://a.com",
                                       short_link2: "https://a.com",
                                       full_short_link2: "https://a.com",
                                       share_link: "https://a.com",
                                       full_share_link: "https://a.com",
                                       original_link: "https://a.com")
    }
}

enum MockError: Error {
    case error
}
