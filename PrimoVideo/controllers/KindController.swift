//
//  KindController.swift
//  PrimoVideo
//
//  Created by digital on 05/06/2023.
//

import Foundation

class KindController: ObservableObject {
    @Published var movies: HomeMovies? = nil
    @Published var isLoading = true
    let myParameter: Int
    
    init(iId: Int) {
        self.myParameter = iId
    }
    
    // Async Movie
    func fetchGenreMovies() async-> HomeMovies? {
        let api_url = "https://api.themoviedb.org/3/discover/movie"
        let api_key = "9a8f7a5168ace33d2334ba1fe14a83fb"
        let api_id = myParameter
        
        let link = URL(string:
                            "\(api_url)?api_key=\(api_key)&sort_by=popularity.desc&with_genres=\(api_id)")!
        let session = URLSession.shared
        do {
            let request = URLRequest(url: link)
            let (data, response) = try await session.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Réponse invalide")
                    return nil
                }
                guard let jsonString = String(data: data, encoding: .utf8) else {
                    print("Impossible de convertir les données en chaîne JSON")
                    return nil
                    
                }
            print("Réponse valide : \(jsonString)")
            Task{
                @MainActor in
                isLoading = false
            }
            return try JSONDecoder().decode(HomeMovies.self, from: data)
        } catch {
            print("Erreur : \(error.localizedDescription)")
            return nil
        }
    }
}
