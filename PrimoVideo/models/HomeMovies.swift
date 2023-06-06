//
//  HomeMovies.swift
//  PrimoVideo
//
//  Created by digital on 17/04/2023.
//

import Foundation

struct HomeMovies: Decodable
{    
    // Elements
    var aMovieList: [HomeMovie]
    
    // CodeKeys
    enum CodingKeys: String, CodingKey {
        case aMovieList = "results"
    }
}
