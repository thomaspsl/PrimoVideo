//
//  GenreView.swift
//  PrimoVideo
//
//  Created by digital on 05/06/2023.
//

import SwiftUI

struct KindView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isShowingDetails = false
    @State var selectedMovieID: Int? = nil
    @State var movies: HomeMovies! = nil
    @StateObject private var controller: KindController
    let myParameter: Int
    let myParameterName: String

    init(iIdentify: Int, iName: String) {
        self.myParameter = iIdentify
        self.myParameterName = iName
        _controller = StateObject(wrappedValue: KindController(iId: iIdentify))
    }

    // Body
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // Header
            HStack{
                  Image("Menu")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 35, height: 35)
                      .hidden()     
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
                      .hidden()
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
                
            } else if movies != nil {
                // Type of Genre
                Text("Catégorie : \(myParameterName)")
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
                                   Text("\(movie.title)")
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
                           .allowsHitTesting(index%2 == 1)
                           .ignoresSafeArea()
                           
                           // Display a sheet every other time
                           .onTapGesture {
                               if(index%2 == 1){
                                   selectedMovieID = movie.id
                                   isShowingDetails = true
                               }
                           }
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
                                self.movies = await controller.fetchGenreMovies()
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
                self.movies = await controller.fetchGenreMovies()
            }
        }
        
        // Change return button
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                Text("Retour")
                    .foregroundColor(.white)
            }
        })
    }
}
    
struct KindView_Previews: PreviewProvider {
    static var previews: some View {
        KindView(iIdentify: 28, iName: "Action")
    }
}
