//
//  ApiError.swift
//  Shortly
//
//  Created by Abdullah Muhammad Zubair on 2/24/22.
//

import Foundation

enum ApiError: Error {
    case statusCode
    case decoding
    case invalidURL
    case other(Error)
    
    static func map(_ error: Error) -> ApiError {
        return (error as? ApiError) ?? .other(error)
    }
}
