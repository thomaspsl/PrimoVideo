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
        let link = URL(string:
                            "\(TMDB.apiUrl)/3/discover/movie?api_key=\(TMDB.apiKey)&sort_by=popularity.desc&with_genres=\(myParameter)&language=\(TMDB.apiLanguage)")!
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
