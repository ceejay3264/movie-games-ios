//
//  MovieGuessViewModel.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import Foundation

class MovieGuessViewModel: ObservableObject {
    @Published var guessesRemaining: Int = 6
    
    @Published var currentMovie: Movie?
    
    public func getPosterURL() -> String {
        if let currentMovie, let posterPath = currentMovie.poster_path {
            let basePosterURL = "https://image.tmdb.org/t/p/original"
            return basePosterURL + posterPath
        } else {
            return ""
        }
    }
    
    public func incorrectGuess() {
        if guessesRemaining == 0 {
            guessesRemaining = 6
        } else {
            guessesRemaining -= 1
        }
    }
    
    public func startGame() {
        currentMovie = nil
        guessesRemaining = 6
        getMovie()
    }
    
    private func getMovie() {
        let currentDate = Date()
        let currentyear = currentDate.get(.year)
        let randomYear = Int.random(in: 1950..<currentyear)
        let randomYearString = String(randomYear)
        
        APIService.shared.get(urlString: APIEndpoints.movieEndpoint(year: randomYearString)) {[weak self] (result: Result<MoviesResponse, Error>)  in
            guard let self = self else {return}
            
            switch result {
                case .success(let response):
                    if let movies = response.results {
                        let randomIndex = Int.random(in: 0..<movies.count-1)
                        DispatchQueue.main.async {
                            self.currentMovie = movies[randomIndex]
                        }
                    }
                
            case .failure( _):
                    break
            }
        }
        
    }
}
