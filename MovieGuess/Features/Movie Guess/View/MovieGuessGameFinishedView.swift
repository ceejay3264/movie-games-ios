//
//  MovieGuessGameFinishedView.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/16/24.
//

import SwiftUI

struct MovieGuessGameFinishedView: View {
    @Binding var gameResult: Bool?
    @Binding var posterURL: String
    @Binding var guessesRemaining: Int
    
    var body: some View {
        if let gameResult = gameResult {
            if gameResult {
                MovieGuessWinView(posterURL: $posterURL, guessesRemaining: $guessesRemaining)
            } else {
                MovieGuessLoseView(posterURL: $posterURL)
            }
        }
    }
}
