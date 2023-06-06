//
//  tmdb.swift
//  PrimoVideo
//
//  Created by digital on 06/06/2023.
//

import Foundation

struct TMDB
{
    // Elements
    static let apiUrl: String = "https://api.themoviedb.org"
    static let apiKey: String = "9a8f7a5168ace33d2334ba1fe14a83fb"
    static let apiLanguage: String = "\(Locale.preferredLanguages.first ?? "UK-uk")"
}

