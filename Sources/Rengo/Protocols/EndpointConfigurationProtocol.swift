//
//  EndpointConfigurationProtocol.swift
//  
//
//  Created by Paulo Gutemberg de Sousa Cavalcante on 23/03/23.
//

import Foundation

public protocol EndpointConfigurationProtocol {
    
    //Example: api.flicker.com
    /// The target's base `URL`.
    var baseURL: String { get }
    
    //Example: /service/rest/
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    //Example: GET
    /// The type of HTTP task to be performed.
    var method: HTTPMethod { get }
    
    //Example: URLQueryItem(name: "api_key", value: API_KEY)
    var parameters: [String: String]? { get }
    
    var headers: [String: String]? { get }
}

