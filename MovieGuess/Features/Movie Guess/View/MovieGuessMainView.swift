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
    @State var isPresented = false
    @State var showWrongGuessAlert = false
    @State var showSheet: Bool = false
    @State var gameResult: Bool?
    
    var body: some View {
        ZStack {
            
            List {
                
                // If there is a game result, show the play again button
                if let result = gameResult {
                    HStack {
                        Spacer()
                        playAgainButton
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                } else {
                    // If the game isn't finished yet, show the game buttons/info
                    HStack {
                        Text("Guesses remaining: \(viewModel.guessesRemaining)")
                            .font(.headline)
                            .bold()
                            .listRowSeparator(.hidden)
                        
                        Spacer()
                        
                        HStack {
                            getHintButton
                            skipButton
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                
                // Hint UI
                if !viewModel.hintArray.isEmpty {
                    VStack(spacing: 8){
                        ForEach(viewModel.hintArray, id: \.self) { item in
                            HStack {
                                Text(item)
                                    .font(.body)
                                Spacer()
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                
                // Movie poster UI
                if let url = URL(string: viewModel.posterURL) {
                    AsyncImage(url: url) { image in
                        image.image?.resizable()
                            .scaledToFit()
                            .blur(radius: viewModel.isGameWon ?? false ? 0 : CGFloat(6+viewModel.guessesRemaining))
                            .padding(.top, 16.0)
                    }
                    .listRowSeparator(.hidden)
                } else {
                    //Something went wrong alert
                }
                
            }
            .listStyle(.plain)
            .onChange(of: guessQuery, {
                viewModel.searchQueryChanged(query: guessQuery)
            })
            .searchable(text: $guessQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Guess the movie title...")
            .onSubmit(of: .search) {
                viewModel.searchMovies(query: guessQuery)
            }
            .searchSuggestions {
                ForEach(viewModel.searchResults) { item in
                    if let title = item.title {
                        Button {
                            if let isGameWon = viewModel.isGameWon { return } // Game finished. Prevent more guesses
                            
                            if viewModel.selectGuess(title: title) {
                                madeWrongGuess()
                            }
                            
                            if let result = viewModel.gameResult() {
                                gameResult = result
                                showSheet = true
                            }
                        } label: {
                            Text(title)
                        }
                    }
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 8.0)
            .onAppear() {
                viewModel.startGame()
            }
            .navigationTitle("Guess the Movie Poster!")
            .sheet(isPresented: $showSheet) {
                if let result = gameResult {
                    if result {
                        MovieGuessWinView(posterURL: $viewModel.posterURL, guessesRemaining: $viewModel.guessesRemaining)
                    } else {
                        MovieGuessLoseView(posterURL: $viewModel.posterURL)
                    }
                }
            }
            
            if showWrongGuessAlert {
                VStack {
                    wrongGuessAlert
                        .transition(.move(edge: .bottom))
                    Spacer()
                }
                
            }
        }
            
    }
    
    var getHintButton: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                viewModel.giveHint()
            }
        }) {
            Text("Get hint")
                .font(.headline)
                .bold()
        }
        .buttonStyle(.borderedProminent)
    }
    
    var skipButton: some View {
        Button(action: {
            viewModel.startGame()
            gameResult = nil
        }) {
            Text("Skip")
                .font(.headline)
                .bold()
        }
        .buttonStyle(.bordered)
    }
    
    var playAgainButton: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                viewModel.startGame()
                gameResult = nil
            }
        }) {
            Text("Play Again")
                .font(.headline)
                .bold()
        }
        .buttonStyle(.borderedProminent)
        .listRowSeparator(.hidden)
    }
    
    var wrongGuessAlert: some View {
        HStack {
            Text("Nope! That's not the right movie title!")
                .font(.body)
            
            Image(systemName: "x.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(.red)
        }
        .padding()
        .background(Color.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 8
            )
        )
        .shadow(color: .black.opacity(0.3), radius: 20.0, x: 0.0, y: 2.0)
    }
    
    func madeWrongGuess() {
        withAnimation(.spring) {
            showWrongGuessAlert = true
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            showWrongGuessAlert = false
        }
    }
    
}

#Preview {
    MovieGuessMainView()
}
