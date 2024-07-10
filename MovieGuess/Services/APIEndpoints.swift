//
//  APIEndpoints.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import Foundation

class APIEndpoints {
    static public var baseURL: String = "https://api.themoviedb.org"
    
    static func movieEndpoint(year: String) -> String {
        let endpointURL = APIEndpoints.baseURL + "/3/discover/movie?year=" + year
        return endpointURL
    }
}
