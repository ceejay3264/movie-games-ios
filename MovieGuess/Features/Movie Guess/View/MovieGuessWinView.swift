//
//  MovieGuessWinView.swift
//  MovieGuess
//
//  Created by Christopher Cordero on 7/10/24.
//

import SwiftUI

struct MovieGuessWinView: View {
    @Binding var posterURL: String
    @Binding var guessesRemaining: Int
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.title)
                    })
                }
                Text("That's Correct!")
                    .font(.largeTitle)
                    .bold()
                
                if 6-guessesRemaining == 1 {
                    Text("You guessed the movie in \(String(6-guessesRemaining)) try!")
                        .font(.title2)
                } else {
                    Text("You guessed the movie in \(String(6-guessesRemaining)) tries!")
                        .font(.title2)
                }
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundStyle(.green)
                
                if let url = URL(string: posterURL) {
                    AsyncImage(url: url) { image in
                        image.image?.resizable()
                            .scaledToFit()
                            .padding(8)
                    }
                }
            }
            .padding(24)
            
        }
    }
}
