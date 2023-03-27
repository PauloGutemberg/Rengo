//
//  APIError.swift
//  
//
//  Created by Paulo Gutemberg de Sousa Cavalcante on 24/03/23.
//

import Foundation

public enum APIError: Error {
    
    case decodingError
    case emptyData
    case invalidURL
    case invalidResponse
    case otherError(Error)
    
    var message: String {
        switch self {
        case .decodingError:
            return "failed to decode the object"
        case .emptyData:
            return "Empty data"
        case .invalidURL:
            return "invalid URL"
        case .invalidResponse:
            return "invalid Response"
        case .otherError(let error):
            return "\(error)"
        }
    }
}
