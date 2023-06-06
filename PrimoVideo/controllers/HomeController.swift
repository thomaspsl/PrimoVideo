//
//  HomeController.swift
//  PrimoVideo
//
//  Created by digital on 23/05/2023.
//

import SwiftUI

class HomeController: ObservableObject {
    @Published var movies: HomeMovies? = nil
    @Published var isLoading = true

    //
    func fetchRated() async-> HomeMovies? {
        let link = URL(string:
                            "\(TMDB.apiUrl)/3/movie/top_rated?api_key=\(TMDB.apiKey)&language=\(TMDB.apiLanguage)")!
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
    
    // Async Movies
    func fetchMovies() async-> HomeMovies? {
        let link = URL(string:
                            "\(TMDB.apiUrl)/3/movie/popular?api_key=\(TMDB.apiKey)&language=\(TMDB.apiLanguage)")!
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
    
    // Async Genres
    func fetchGenres() async-> HomeGenres? {
        let link = URL(string:
                            "\(TMDB.apiUrl)/3/genre/movie/list?api_key=\(TMDB.apiKey)&language=\(TMDB.apiLanguage)")!
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
            return try JSONDecoder().decode(HomeGenres.self, from: data)
        } catch {
            print("Erreur : \(error.localizedDescription)")
            return nil
        }
    }
}
