//
//  UrlShortenApi.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/24/22.
//

import Foundation
import Combine

protocol UrlShortenServiceProtocol {
    func urlShorten(fullUrl: String?) -> AnyPublisher<ShortUrl, Error>
}

class UrlShortenApi: UrlShortenServiceProtocol {
    let baseUrl = "https://api.shrtco.de/v2/shorten"
    
    func urlShorten(urlString: String?) async throws -> (ShortUrl?, ApiError?) {
        
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "url", value: urlString)
        ]
        
        let session = URLSession.shared
        guard let absoluteURL: URL = urlComponents?.url?.absoluteURL
        else {
            return (nil, ApiError.invalidURL)
        }
        
        let urlRequest = URLRequest(url: absoluteURL)
        // Used the async variant of URLSession to fetch data
        
        let (data, _) = try await session.data(for: urlRequest)
        
        // Parse the JSON data
        let shortUrl = try JSONDecoder().decode(ShortUrl.self, from: data)
        return (shortUrl, nil)
    }
    
    
    func urlShorten(fullUrl: String?) -> AnyPublisher<ShortUrl, Error> {
        
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "url", value: fullUrl)
        ]
        
        let session = URLSession.shared
        
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        // promise type is Result<ShortUrl, Error>
        return Future<ShortUrl, Error> { promise in
            
            guard let absoluteURL: URL = urlComponents?.url?.absoluteURL
            else {
                promise(.failure(ApiError.invalidURL))
                return
            }
            var urlRequest = URLRequest(url: absoluteURL)
            urlRequest.httpMethod = "GET"
            
            dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                
                guard (response as! HTTPURLResponse).statusCode == 201
                else {
                    promise(.failure(ApiError.invalidURL))
                    return
                }
                
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    guard let jsonDict: [String: Any] = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    else {
                        promise(.failure(ApiError.decoding))
                        return
                    }
                    guard let jsonData = try? JSONEncoder().encode(jsonDict["result"] as! [String : String])
                    else {
                        promise(.failure(ApiError.decoding))
                        return
                    }
                    let shortUrl = try JSONDecoder().decode(ShortUrl.self, from: jsonData)
                    promise(.success(shortUrl))
                } catch {
                    promise(.failure(ApiError.decoding))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}

