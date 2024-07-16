//
//  MovieGuessLoseScreen.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import SwiftUI

struct MovieGuessLoseView: View {
    @Binding var posterURL: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack (spacing: 48){
                VStack(spacing: 16) {
                    Text("Womp! Womp!")
                        .font(.largeTitle)
                        .bold()
                    Text("Sorry, but you ran out of guesses!")
                        .font(.title2)
                    
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(.red)
                    
                    if let url = URL(string: posterURL) {
                        AsyncImage(url: url) { image in
                            image.image?.resizable()
                                .scaledToFit()
                                .padding(8)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
