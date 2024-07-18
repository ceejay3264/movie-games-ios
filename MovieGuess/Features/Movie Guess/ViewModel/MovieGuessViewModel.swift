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
    @Published var searchResults: [Movie] = []
    @Published var posterURL: String = ""
    @Published var hintArray: [String] = []
    @Published var isGameWon: Bool? = nil
    
    private var hintCount = 0
    private var timer: Timer?
    private var wrongGuessTimer: Timer?
    
    static private func getPosterURL(movie: Movie?) -> String {
        if let movie = movie, let posterPath = movie.poster_path {
            let basePosterURL = "https://image.tmdb.org/t/p/original"
            return basePosterURL + posterPath
        } else {
            return ""
        }
    }
    
    public func selectGuess(title: String) -> Bool {
        if title == currentMovie?.title {
            guessesRemaining -= 1
            isGameWon = true
            return false
        } else {
            incorrectGuess()
            return true
        }
    }
    
    public func gameResult() -> Bool? {
        return isGameWon
    }
    
    public func incorrectGuess() {
        guessesRemaining -= 1
        if guessesRemaining == 0 {
            isGameWon = false
        }
    }
    
    public func giveHint() {
        
        switch hintCount {
            case 0:
                // Give release date hint if it exists
                if let release_date = currentMovie?.release_date {
                    hintArray.append("Released on: \(formatDateString(dateString: release_date))")
                } else {
                    // If release date is nil, recall giveHint() but try to give the genre hint in the second case
                    hintCount += 1
                    giveHint()
                    return
                }
            case 1:
                // Give genres hint if they exist
                if let genreIds = currentMovie?.genre_ids {
                    let genresString = Genres.shared.genresToString(genreIds: genreIds)
                    hintArray.append("Genres: \(genresString)")
                } else {
                    // If genre IDs are nil, recall giveHint() but try to give the overview hint in the third case
                    hintCount += 1
                    giveHint()
                    return
                }
            case 2:
                // Give overview hint if it exists and is not empty
                if let overview = currentMovie?.overview, !overview.isEmpty {
                    hintArray.append("Overview: \(overview)")
                } else {
                    // If overview hint is nil, there are no more hints to give
                    return
                }
                
            default:
                break
        }
        
        hintCount += 1
    }
    
    public func startGame() {
        isGameWon = nil
        currentMovie = nil
        hintArray = []
        hintCount = 0
        searchResults = []
        guessesRemaining = 6
        getMovie()
    }
    
    private func formatDateString(dateString: String) -> String {
        // Create a DateFormatter for the input string
        // Create a DateFormatter for the input string
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        // Convert the string to a Date object
        if let date = inputFormatter.date(from: dateString) {
            // Create another DateFormatter for the output string
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd/yyyy"
            
            // Convert the Date object back to a string in the desired format
            let formattedDateString = outputFormatter.string(from: date)
            return formattedDateString
        } else {
            return "N/A"
        }
    }
    
    private func getMovie() {
        let currentDate = Date()
        let currentyear = currentDate.get(.year)
        let randomYear = Int.random(in: 1950..<currentyear)
        let randomYearString = String(randomYear)
        
        APIService.shared.get(urlString: APIEndpoints.getMoviesEndpoint(year: randomYearString)) {[weak self] (result: Result<MoviesResponse, Error>)  in
            guard let self = self else {return}
            
            switch result {
                case .success(let response):
                    if let movies = response.results {
                        let randomIndex = Int.random(in: 0..<movies.count-1)
                        
                        // Make UI change from the main thread
                        DispatchQueue.main.async {
                            self.currentMovie = movies[randomIndex]
                            if let currentMovie = self.currentMovie {
                                self.posterURL = MovieGuessViewModel.getPosterURL(movie: currentMovie)
                            }
                        }
                    }
                
                case .failure( _):
                    break
            }
        }
        
    }
    
    public func searchQueryChanged(query: String) {
        // Invalidate any existing timer
        // Schedule a timer for 3 seconds to call search movies
        // If user doesn't type for 3 seconds, then the search will be triggered with the current query value
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            guard let self = self else {return}
            
            self.searchMovies(query: query)
        }
    }
    
    public func searchMovies(query: String) {
        timer?.invalidate()
        timer = nil
        APIService.shared.get(urlString: APIEndpoints.searchMoviesEndpoint(query: query)) {[weak self] (result: Result<MoviesResponse, Error>)  in
            guard let self = self else {return}
            
            switch result {
                case .success(let response):
                    if let movies = response.results {
                        
                        // Make UI change from the main thread
                        DispatchQueue.main.async {
                            self.searchResults = movies
                        }
                    }
                
            case .failure( _):
                    break
            }
        }
    }
}
