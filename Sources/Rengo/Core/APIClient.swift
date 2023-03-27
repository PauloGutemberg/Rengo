//
//  APIClient.swift
//  
//
//  Created by Paulo Gutemberg de Sousa Cavalcante on 24/03/23.
//

import Foundation
import Combine

public final class APIClient<T: Decodable>{
    
    let session: URLSession
    let endpointConfiguration: EndpointConfigurationProtocol
    
    public init(session: URLSession = .shared, endpointConfiguration: EndpointConfigurationProtocol) {
        self.session = session
        self.endpointConfiguration = endpointConfiguration
    }
    
    public func sendRequest(completion: @escaping(Result<T, APIError>) -> Void) {
        guard let url = buildURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = buildURLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode), error == nil else {
                if let error = error {
                    completion(.failure(.otherError(error)))
                }else{
                    completion(.failure(APIError.invalidResponse))
                }
                return
            }
            
            do{
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            }catch{
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    private func buildURL() -> URL? {
        var components = URLComponents(string: endpointConfiguration.baseURL)
        components?.queryItems = endpointConfiguration.parameters?.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components?.url
    }
    
    private func buildURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url.appendingPathComponent(endpointConfiguration.path))
        request.httpMethod = endpointConfiguration.method.rawValue
        if let headers = endpointConfiguration.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    /*public func request<T: Decodable>(_ endpointConfiguration: EndpointConfigurationProtocol) -> AnyPublisher<T, APIError> {
        let request = createURLRequest(with: endpointConfiguration)
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> T in
                guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw APIError.failedRequest
                }
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    print("Unable to Decode Response \(error)")
                    throw APIError.invalidResponse
                }
            }
            .mapError { error -> APIError in
                switch error {
                case let apiError as APIError:
                    return apiError
                case URLError.notConnectedToInternet:
                    return APIError.unreachable
                default:
                    return APIError.failedRequest
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createURLRequest(with endpointConfiguration: EndpointConfigurationProtocol) -> URLRequest {
        var request = URLRequest(url: endpointConfiguration.baseURL.appendingPathComponent(endpointConfiguration.path))
        request.httpMethod = endpointConfiguration.method.rawValue
        request.allHTTPHeaderFields = endpointConfiguration.headers
        if let urlString = request.url?.absoluteString {
            switch endpointConfiguration.parameters {
            case .none:
                request.url = URL(string: "\(urlString)")
            case .url(_):
                request.url = URL(string: "\(urlString)?\(endpointConfiguration.parameters.encoding)")
            }
        }
        return request
    }*/
}
