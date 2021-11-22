//
//  BirdInfo.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/21/21.
//

import SwiftUI

struct BirdInfo: View {
    @ObservedObject var birdData = ReadData()
    @Binding var name: String
    @State var imageURL: String = ""
    var iNaturalistData: Any = []
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment:.leading) {
                    if self.imageURL != "" {
                        AsyncImage(url: URL(string: self.imageURL)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: screenSize.width)
                        .overlay(alignment:.bottomLeading) {
                            VStack {
                                VStack {
                                    HStack {
                                        Text(getInfo().common)
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .shadow(radius: 10)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(getInfo().scientific)
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
                    Spacer(minLength: 25)
                    VStack(alignment:.leading) {
                        HStack {
                            Text("Common Name")
                            Divider()
                            Text(getInfo().common)
                        }
                        Divider()
                        HStack {
                            Text("Scientific Name")
                            Divider()
                            Text(getInfo().scientific)
                        }
                        Divider()
                        HStack {
                            Text("Family")
                            Divider()
                            Text(getInfo().family)
                        }
                        Divider()
                        HStack {
                            Text("Order")
                            Divider()
                            Text(getInfo().order)
                        }
                    }
                }
                .padding()
                HStack {
                    Text("Similar Species")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()
                HStack {
                    VStack (alignment:.leading) {
                        ForEach (getSimilarSpecies(), id: \.scientific) { s in
                            NavigationLink(destination: {
                                NavigationLazyView(BirdInfo(name: .constant(s.scientific)))
                                    .navigationTitle("")
                                    .navigationBarHidden(true)
                            }) {
                                VStack(alignment:.leading) {
                                    HStack {
                                        Text("\(s.common)")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    Divider()
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }.onAppear {
            loadData(speciesName: name)
        }
    }
    private func getSimilarSpecies() -> [Bird] {
        return birdData.getGenus(genus: getInfo().genus, scientific: getInfo().scientific)
    }
    private func getInfo() -> Bird {
        return birdData.getInfo(scientific: self.name)
    }
    private func setImageData(imageURL: String) {
        print(imageURL)
        self.imageURL = imageURL
    }
    private func loadData(speciesName: String) -> Void {
        let speciesText = speciesName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.inaturalist.org/v1/taxa?q=\(speciesText!)&rank=species")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            if let data = data {
                do {
                    let bird = try JSONDecoder().decode(iNatResponse.self, from: data)
                    print(bird.results[0].default_photo.medium_url)
                    setImageData(imageURL: bird.results[0].default_photo.medium_url)
                } catch {
                    print(error)
                }
                //            print(bird)
            } else if let error = error {
                print("Request Failed \(error)")
            }
        }
        task.resume()
    }
    
}

struct BirdInfo_Previews: PreviewProvider {
    static var previews: some View {
        BirdInfo(name: .constant("Haliaeetus leucocephalus"))
    }
}
