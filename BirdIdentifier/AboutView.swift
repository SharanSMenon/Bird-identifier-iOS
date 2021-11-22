//
//  AboutView.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/21/21.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Text("About")
                    .font(.title).bold()
                Spacer()
            }
            Divider()
            Text("An app created to identify birds given an image. The model is capable of identifying around 900 species of birds.")
            Text("")
            Text("Simplly pick an image from your camera roll or shoot a photo, and the AI will identify it for you. Click on the classification to learn more about the species and view similar species.")
            Spacer()
            GroupBox(label: Label("Web Version", systemImage: "safari")) {
                HStack {
                    Link("Click here to view the Web Version",
                         destination: URL(string: "https://bird-id-app.vercel.app")!)
                    Spacer()
                }
            }
            GroupBox(label: Label("Links", systemImage: "link.circle")) {
                HStack {
                    VStack(alignment: .leading) {
                        Link("Code on Github", destination: URL(string: "https://github.com/SharanSMenon/Bird-identifier-iOS")!)
                    }
                    Spacer()
                }
            }
            Text("Model from TFHub. Trained on iNaturalist 2017")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Created By Sharan Sajiv Menon")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
