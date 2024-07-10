//
//  APIService.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case PUT
    case POST
    case DELETE
}

class APIService {
    static let shared = APIService()
    
    private func makeRequest<T: Decodable>(urlString: String, httpMethod: HTTPMethod, bodyData: Data?=nil, completion: @escaping (Result<T, Error>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var apiKey: String?
        
        do {
            apiKey = try Configuration.value(for: "API_KEY")
        } catch {
            completion(.failure(URLError(.unknown)))
            return
        }
        
        guard let apiKey = apiKey else {
            completion(.failure(URLError(.unknown)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if let body = bodyData {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.allHTTPHeaderFields = [
            "accept" : "application/json",
            "Authorization" : "Bearer " + apiKey
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let _ = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(jsonData))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
            
        }.resume()
        
    }
    
    public func get<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> ()) {
        return makeRequest(urlString: urlString, httpMethod: .GET, completion: completion)
    }
}
