//
//  FilmController.swift
//  PrimoVideo
//
//  Created by digital on 05/06/2023.
//

import Foundation

class FilmController: ObservableObject {
    @Published var movie: FilmMovie? = nil
    @Published var isLoading = true
    let myParameter: Int
    
    init(iId: Int) {
        self.myParameter = iId
    }
    
    // Async Movie
    func fetchMovie() async-> FilmMovie? {
        let api_url = "https://api.themoviedb.org/3/movie"
        let api_id = myParameter
        let api_key = "9a8f7a5168ace33d2334ba1fe14a83fb"
        
        let link = URL(string:
                            "\(api_url)/\(api_id)?api_key=\(api_key)&append_to_response=videos")!
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
            return try JSONDecoder().decode(FilmMovie.self, from: data)
        } catch {
            print("Erreur : \(error.localizedDescription)")
            return nil
        }
    }
}
