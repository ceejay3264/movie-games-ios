//
//  HomeView.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import SwiftUI

struct HomeView: View {
    @State private var presentGame = false
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Guess the Movie Poster!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Guess the movie poster in six tries or less.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    presentGame = true
                }) {
                    Text("Play")
                        .font(.title)
                        .bold()
                        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationDestination(isPresented: $presentGame) {
                MovieGuessMainView()
            }
            .onAppear() {
                viewModel.getGenres()
            }
        }
    }
}
