//
//  BirdInfoImage.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/22/21.
//

import SwiftUI

struct BirdInfoImage: View {
    @State var imageURL: String
    @State var bird: Bird
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: screenSize.width)
        .overlay(alignment:.bottomLeading) {
            VStack {
                VStack {
                    HStack {
                        Text(bird.common)
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        Spacer()
                    }
                    HStack {
                        Text(bird.scientific)
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                            .shadow(radius: 10)
                        Spacer()
                    }
                }
            }
            .padding()
            .shadow(radius: 10)
        }
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct BirdInfoImage_Previews: PreviewProvider {
    static var previews: some View {
        BirdInfoImage(imageURL: "https://static.inaturalist.org/photos/6149726/medium.jpg",
                      bird: ReadData().getInfo(scientific: "Haliaeetus leucocephalus"))
    }
}
