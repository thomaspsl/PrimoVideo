//
//  HomeMovie.swift
//  PrimoVideo
//
//  Created by digital on 22/05/2023.
//

import Foundation

struct HomeMovie: Hashable, Decodable
{
    // Elements
    let id: Int
    let original_title : String;
    let poster_path : String;
    let release_date: String;
    let overview: String;
    
    func format_picture()->String{
        return "https://www.themoviedb.org/t/p/w600_and_h900_bestv2\(self.poster_path)"
    }
    
    func format_synopsis()->String{
        let maxLength = 100
        if overview.count <= maxLength {
            return overview
        } else {
            let endIndex = overview.index(overview.startIndex, offsetBy: maxLength)
            return String(overview[..<endIndex]) + "..."
        }
    }
}
