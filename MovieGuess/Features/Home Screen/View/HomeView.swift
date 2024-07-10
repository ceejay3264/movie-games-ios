//
//  HomeView.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import SwiftUI

struct HomeView: View {
    @State private var presentGame = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Movie Guess")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
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
        }
    }
}
