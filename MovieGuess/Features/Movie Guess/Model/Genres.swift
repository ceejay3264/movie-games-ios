//
//  Genres.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import Foundation

struct Genre: Codable, Identifiable {
    var id: Int
    var name: String
}

struct GenresResponse: Codable {
    var genres: [Genre]?
}

class Genres: ObservableObject {
    static var shared = Genres()
    
    @Published var genreDictionary: [Int : String] = [:]
    
    public func genresToString(genreIds: [Int]) -> String {
        var genreString = ""
        
        for index in genreIds.indices {
            let genreName = genreDictionary[genreIds[index]]
            
            if let genreName = genreName {
                if index == 0 {
                    genreString += genreName
                } else {
                    genreString += ", \(genreName)"
                }
            }
        }
        
        return genreString
    }
}
