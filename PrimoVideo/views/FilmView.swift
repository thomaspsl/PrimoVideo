//
//  FilmView.swift
//  PrimoVideo
//
//  Created by digital on 04/04/2023.
//

import SwiftUI
    
struct FilmView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var movie: FilmMovie! = nil
    @StateObject private var controller: FilmController
    let myParameter: Int
    
    init(iIdentify: Int) {
        self.myParameter = iIdentify
        _controller = StateObject(wrappedValue: FilmController(iId: iIdentify))
    }

    // Body
    var body: some View {
        
        VStack(alignment: .leading) {
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
                
            } else if movie != nil {
                // Display Movie
                GeometryReader { gp in
                    AsyncImage(url: URL(string: movie.format_picture())) { image in
                        image
                            .scaledToFill()
                            .clipped()
                            .ignoresSafeArea()
                        
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: gp.size.width, height: 350)
                }
                .frame(height: 405)

                VStack(alignment: .leading, spacing: 15) {
                    Text(movie.sTitle)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    HStack{
                        ForEach(0..<movie.format_rate(), id: \.self) { index in
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(red: 0.98, green: 0.74, blue: 0.31, opacity: 1.00))
                        }
                        ForEach(0..<5-movie.format_rate(), id: \.self) { index in
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58, opacity: 1.00))
                        }
                        
                        Text("\(movie.format_rate())/5")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                        .overlay(Color.black)
                    
                    Text("\(movie.format_duration()) - \(movie.format_categorys()) - \(movie.sReleaseDate)")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .padding(EdgeInsets.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    
                    Text(movie.sSynopsis)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button{
                        UIApplication.shared.open(URL(string: movie.format_trailer())!)
                    } label: {
                        Text("Watch Now")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, maxHeight: 25)
                            .padding()
                    }
                    .background(Color(red: 0.20, green: 0.49, blue: 1.00))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(EdgeInsets.init(top: 10, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets.init(top: 0, leading: 15, bottom: 5, trailing: 15))
                
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
                                self.movie = await controller.fetchMovie()
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
        .onAppear {
            Task {
                self.movie = await controller.fetchMovie()
            }
        }
    }
}
    
struct FilmView_Previews: PreviewProvider {
    static var previews: some View {
        FilmView(iIdentify: 677179)
    }
}
