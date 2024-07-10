//
//  Movie.swift
//  MovieDisplay
//
//  Created by Christopher Cordero on 7/10/24.
//

import Foundation

struct Movie: Codable, Identifiable {
      var id: Int? // 823464
      var overview: String? // "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own."
      var poster_path: String? // "/v4uvGFAkKuYfyKLGZnYj6l47ERQ.jpg"
      var title: String? // "Godzilla x Kong: The New Empire"
}

struct MoviesResponse: Codable {
    var results: [Movie]?
}
