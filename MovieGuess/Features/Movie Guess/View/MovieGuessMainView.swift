//
//  MovieGuessMainView.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import SwiftUI

struct MovieGuessMainView: View {
    @ObservedObject var viewModel = MovieGuessViewModel()
    
    @State var guessQuery: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Guesses remaining: \(viewModel.guessesRemaining)")
                    .font(.title)
                
                if let url = URL(string: viewModel.getPosterURL()) {
                    AsyncImage(url: url) { image in
                        image.image?.resizable()
                            .scaledToFit()
                            .padding(48)
                            .blur(radius: CGFloat(2*viewModel.guessesRemaining))
                    }
                } else {
                    //Something went wrong alert
                }
                
                Button(action: {
                    viewModel.incorrectGuess()
                }) {
                    Text("Guess")
                        .font(.title)
                        .bold()
                        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .onAppear() {
                viewModel.startGame()
            }
        }
    }
}
