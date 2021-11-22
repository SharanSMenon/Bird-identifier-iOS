//
//  ObservationImage.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/22/21.
//

import SwiftUI

struct ObservationImage: View {
    @State var classification: String;
    @State var common: String;
    @State var image: UIImage;
    let screenSize: CGRect = UIScreen.main.bounds
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .ignoresSafeArea(.all)
            .frame(maxWidth: screenSize.width, maxHeight: 300)
            .overlay(alignment:.bottomLeading) {
                VStack {
                    VStack {
                        HStack {
                            Text(common)
                                .font(.title)
                                .bold()
                                .foregroundColor(Color.white)
                                .shadow(radius: 10)
                            Spacer()
                        }
                        HStack {
                            Text(classification)
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
