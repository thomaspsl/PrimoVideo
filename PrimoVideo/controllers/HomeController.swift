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
        let api_url = "https://api.themoviedb.org/3/movie/top_rated"
        let api_key = "9a8f7a5168ace33d2334ba1fe14a83fb"
        
        let link = URL(string:
                            "\(api_url)?api_key=\(api_key)")!
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
        let api_url = "https://api.themoviedb.org/3/movie/popular"
        let api_key = "9a8f7a5168ace33d2334ba1fe14a83fb"
        
        let link = URL(string:
                            "\(api_url)?api_key=\(api_key)")!
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
        let api_url = "https://api.themoviedb.org/3/genre/movie/list"
        let api_key = "9a8f7a5168ace33d2334ba1fe14a83fb"
        
        let link = URL(string:
                            "\(api_url)?api_key=\(api_key)")!
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
