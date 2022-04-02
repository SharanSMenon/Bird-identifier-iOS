//
//  PredictionListRow.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 12/9/21.
//

import SwiftUI

struct PredictionListRow: View {
    @ObservedObject var birdData = ReadData()
    @State var scientificName: String
    @State var imageURL: String = ""
    @State var showAsyncImage = true;
    
    var body: some View {
        Group {
            NavigationLink(destination:
                            NavigationLazyView(BirdInfo(name: $scientificName))
                            .navigationTitle(getInfo().common)
            ) {
                Group {
                    HStack {
                        if showAsyncImage {
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width:50 ,height:50)
                            .cornerRadius(5)
                            .shadow(radius: 2)
                        } else {
                            Image("nophoto")
                                .resizable()
                                .frame(width:50, height:50)
                                .cornerRadius(5)
                                .shadow(radius:2)
                        }
                        VStack(alignment:.leading) {
                            Text("\(getInfo().common) \(Image(systemName: "chevron.right"))")
                                .bold()
                                .font(.headline)
                            Text(getInfo().scientific)
                                .font(.subheadline)
                        }
                    }
                    .onAppear {
                        loadData(speciesName: scientificName)
                    }
                    .padding(8)
                }
                .background()
                .cornerRadius(5)
            }
        }
    }
    
    func getInfo() -> Bird {
        print(scientificName)
        let data = birdData.getInfo(scientific: scientificName)
        if data.scientific != scientificName {
            let genus = scientificName.components(separatedBy: " ")[0]
            let genusData = birdData.getGenus(genus: genus)
            if (genusData.count == 0) {
                return Bird(scientific: self.scientificName, common: self.scientificName, family: "Unknown", order: "Unknown", genus: "Unknown")
            }
            return genusData[0]
        }
        return data
    }
    
    private func setImageData(imageURL: String) {
        self.imageURL = imageURL
    }
    
    private func loadData(speciesName: String) -> Void {
        let iNat = iNaturalistAPI(scientificName: speciesName);
        iNat.callAPI(completionHandler: { bird in
            if bird.results.count > 0 {
                setImageData(imageURL: bird.results[0].default_photo.medium_url)
                showAsyncImage = true
            } else {
                showAsyncImage = false;
            }
        })
    }
}

struct PredictionListRow_Previews: PreviewProvider {
    static var previews: some View {
        PredictionListRow(scientificName: "Corvus corax")
    }
}
