//
//  HomeViewModel.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    func getGenres() {
        
        APIService.shared.get(urlString: APIEndpoints.getGenresEndpoint()) {(result: Result<GenresResponse, Error>)  in
            
            switch result {
                case .success(let response):
                    if let genreArray = response.genres {
                        var genreDictionary: [Int : String] = [:]
                        
                        for genre in genreArray {
                            genreDictionary.updateValue(genre.name, forKey: genre.id)
                        }
                                
                        DispatchQueue.main.async {
                            Genres.shared.genreDictionary = genreDictionary
                        }
                    }
                
            case .failure( _):
                    break
            }
        }
        
    }
}
