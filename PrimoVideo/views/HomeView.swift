//
//  HomeView.swift
//  PrimoVideo
//
//  Created by digital on 04/04/2023.
//

import SwiftUI

struct HomeView: View {
    @State var isShowingDetails = false
    @State var selectedMovieID: Int? = nil
    @StateObject private var controller = HomeController()
    @State var movies: HomeMovies! = nil
    @State var genres: HomeGenres! = nil
    @State var rated: HomeMovies! = nil
    
    // Body
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                // Header
                HStack{
                    Image("Menu")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Spacer()
                    Image("Primo_Video")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                    Spacer()
                    Image("Bell")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
                .padding(EdgeInsets.init(top: 35, leading: 15, bottom: 0, trailing: 15))
                .frame(height: 75)
                
                if controller.isLoading {
                    // Loading
                    HStack{
                        Spacer()
                        Text("Chargement...")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(EdgeInsets.init(top: 25, leading: 15, bottom: 15, trailing: 15))
                    
                } else if movies != nil && genres != nil && rated != nil {
                    // Display Genres
                    ScrollView(.horizontal) {
                        HStack(spacing: 20){
                            ForEach(genres!.genres, id: \.self) { genre in //
                                NavigationLink(destination: KindView(iIdentify: genre.id, iName: genre.name)){
                                    Text(genre.name)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
                    .scrollIndicators(.hidden)
                    
                    // Order by Popular
                    Text("Par notation :")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(EdgeInsets.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 10){
                            ForEach(Array(rated!.aMovieList.enumerated()), id: \.offset) { index, movie in
                                NavigationLink(destination: FilmView(iIdentify: movie.id)) {

                                    AsyncImage(url: URL(string: movie.format_picture())) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 200)
                                            .clipped()
                                            .ignoresSafeArea()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0))
                    .scrollIndicators(.hidden)
                    .background(Color(red: 0.14, green: 0.24, blue: 0.32, opacity: 1.00))
                    .sheet(isPresented: $isShowingDetails) {
                        if let movieID = selectedMovieID {
                            FilmView(iIdentify: movieID)
                        }
                    }
                    .onChange(of: selectedMovieID) { newValue in
                        isShowingDetails = newValue != nil
                    }
                    
                    // Order by Popular
                    Text("Par popularité :")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(EdgeInsets.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                    
                    // Display Movies
                    ScrollView {
                        ForEach(Array(movies!.aMovieList.enumerated()), id: \.offset) { index, movie in
                            
                            NavigationLink(destination: FilmView(iIdentify: movie.id)) {
                                HStack{
                                    AsyncImage(url: URL(string: movie.format_picture())) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100)
                                            .clipped()
                                            .ignoresSafeArea()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("\(movie.original_title)")
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text("\(movie.release_date)")
                                            .font(.system(size: 17))
                                            .foregroundColor(.white)
                                        
                                            .multilineTextAlignment(.leading)
                                        
                                        Text(movie.format_synopsis())
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.75))
                                        
                                            .multilineTextAlignment(.leading)
                                        
                                    }
                                    .padding(EdgeInsets.init(top: 10, leading: 5, bottom: 10, trailing: 5))
                                }
                                .frame(maxWidth: .infinity, maxHeight: 350, alignment: .topLeading)
                                .background(Color(red: 0.18, green: 0.28, blue: 0.36, opacity: 1.00).clipShape(RoundedRectangle(cornerRadius: 20)))
                                
                                .onTapGesture {
                                    if(index%2 == 1){
                                        selectedMovieID = movie.id
                                        isShowingDetails = true
                                    }
                                }
                                .allowsHitTesting(index%2 == 1)

                                .ignoresSafeArea()
                            }
                        }
                    }
                    .padding(EdgeInsets.init(top: 2, leading: 15, bottom: 0, trailing: 15))
                    .background(Color(red: 0.14, green: 0.24, blue: 0.32, opacity: 1.00))
                    .scrollIndicators(.hidden)
                    .sheet(isPresented: $isShowingDetails) {
                        if let movieID = selectedMovieID {
                            FilmView(iIdentify: movieID)
                        }
                    }
                    .onChange(of: selectedMovieID) { newValue in
                        isShowingDetails = newValue != nil
                    }
                    
                } else {
                    // Error
                    VStack{
                        HStack{
                            Spacer()
                            Text("Une erreur est arrivée")
                                .font(.system(size: 17))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                        
                        HStack{
                            Spacer()
                            Button("Réessayer...") {
                                Task {
                                    self.movies = await controller.fetchMovies()
                                    self.genres = await controller.fetchGenres()
                                    self.rated = await controller.fetchRated()
                                }
                            }
                            Spacer()
                        }
                        
                    }
                    .padding(EdgeInsets.init(top: 25, leading: 15, bottom: 15, trailing: 15))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(red: 0.14, green: 0.24, blue: 0.32, opacity: 1.00))
            .padding(EdgeInsets.init(top: 15, leading: 0, bottom: 20, trailing: 0))
            .ignoresSafeArea()
            .onAppear {
                Task {
                    self.movies = await controller.fetchMovies()
                    self.genres = await controller.fetchGenres()
                    self.rated = await controller.fetchRated()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
