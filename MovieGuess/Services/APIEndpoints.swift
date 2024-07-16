//
//  APIEndpoints.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import Foundation

class APIEndpoints {
    static public var baseURL: String = "https://api.themoviedb.org"
    
    static func getMoviesEndpoint(year: String) -> String {
        let endpointURL = APIEndpoints.baseURL + "/3/discover/movie?year=" + year
        return endpointURL
    }
    
    static func searchMoviesEndpoint(query: String) -> String {
        let endpointURL = APIEndpoints.baseURL + "/3/search/movie?query=" + query
        return endpointURL
    }
    
    static func getGenresEndpoint() -> String {
        let endpointURL = APIEndpoints.baseURL + "/3/genre/movie/list"
        return endpointURL
    }
}
