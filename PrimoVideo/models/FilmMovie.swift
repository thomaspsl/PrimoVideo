//
//  FilmMovie.swift
//  PrimoVideo
//
//  Created by digital on 17/04/2023.
//

import Foundation

struct FilmMovie: Decodable {
    
    // Constructor
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        iId = try container.decode(Int.self, forKey: .iId)
        sTitle = try container.decode(String.self, forKey: .sTitle)
        iRate = try container.decode(Double.self, forKey: .iRate)
        sSubtitle = try container.decode(String.self, forKey: .sSubtitle)
        sReleaseDate = try container.decode(String.self, forKey: .sReleaseDate)
        iDuration = try container.decode(Int.self, forKey: .iDuration)
        aCategoryList = try container.decode([FilmGenre].self, forKey: .aCategoryList)
        sSynopsis = try container.decode(String.self, forKey: .sSynopsis)
        sPicture = try container.decode(String.self, forKey: .sPicture)
        aVideos = try container.decode(FilmTrailers.self, forKey: .aVideos)
    }
    
    // Elements
    let iId: Int
    var sTitle: String
    var iRate: Double
    var sSubtitle: String
    var sReleaseDate: String
    var iDuration: Int
    var aCategoryList: [FilmGenre]
    var sSynopsis: String
    var sPicture: String
    var aVideos: FilmTrailers
    
    // CodeKeys
    enum CodingKeys: String, CodingKey {
        case iId = "id"
        case sTitle = "title"
        case iRate = "vote_average"
        case sSubtitle = "tagline"
        case sReleaseDate = "release_date"
        case iDuration = "runtime"
        case aCategoryList = "genres"
        case sSynopsis = "overview"
        case sPicture = "backdrop_path"
        case aVideos = "videos"
    }
    
    // Functions
    func format_rate()->Int{
        return Int(self.iRate/2)
    }
    
    func format_duration()->String{
        return "\(self.iDuration / 60)h \(self.iDuration % 60)min"
    }
    
    func format_categorys()->String{
        var sFormat = ""
        self.aCategoryList.forEach{ sCaterogie in
            if(sFormat == ""){
                sFormat += sCaterogie.name
            } else{
                sFormat += ", \(sCaterogie.name)"
            }
        }
        return "\(sFormat)"
    }
    
    func format_picture()->String{
        return "https://www.themoviedb.org/t/p/w780\(self.sPicture)"
    }
    
    func format_trailer()->String {
        var sUrl = ""
        for video in aVideos.results {
            if(video.type == "Trailer" && sUrl == ""){
                sUrl = "https://www.youtube.com/watch?v=\(video.key)"
            }
        }
        if(sUrl == ""){
            sUrl = "https://www.youtube.com/"
        }
        return sUrl
    }
}
