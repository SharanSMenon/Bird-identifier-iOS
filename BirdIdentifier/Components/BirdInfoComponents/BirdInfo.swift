//
//  BirdInfo.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/21/21.
//

import SwiftUI

struct BirdInfo: View {
    @ObservedObject var birdData = ReadData()
    @Binding var name: String;
    @State var imageURL: String = "";
    @State var hideNavigationBar: Bool = false;
    @State var showSimilarSpecies: Bool = true;
    
    var iNaturalistData: Any = []
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading) {
                if self.imageURL != "" {
                    BirdInfoImage(imageURL: self.imageURL, bird: getInfo())
                }
                Spacer(minLength: 25)
                BirdInfoTable(birdInfo: getInfo())
            }
            .padding()
            if showSimilarSpecies {
                BirdInfoSimilarSpecies(similarSpecies: getSimilarSpecies())
            }
        }.onAppear {
            loadData(speciesName: name)
        }
    }
    private func getSimilarSpecies() -> [Bird] {
        let genus = birdData.getGenus(genus: getInfo().genus, scientific: getInfo().scientific)
        if genus.count == 0 {
            return birdData.getFamily(family: getInfo().family, scientific: getInfo().scientific)
        }
        return genus
    }
    private func getInfo() -> Bird {
        print(self.name)
        let data = birdData.getInfo(scientific: self.name)
        if data.scientific != self.name {
            print(self.name)
            let genus = self.name.components(separatedBy: " ")[0]
            let genusData = birdData.getGenus(genus: genus)
            if (genusData.count == 0) {
                return Bird(scientific: self.name, common: "Unknown", family: "Unknown", order: "Unknown", genus: "Unknown")
            }
            return genusData[0]
        }
        return data
    }
    private func setImageData(imageURL: String) {
        print(imageURL)
        self.imageURL = imageURL
    }
    private func loadData(speciesName: String) -> Void {
        let iNat = iNaturalistAPI(scientificName: speciesName)
        iNat.callAPI(completionHandler: {bird in
            if bird.results.count > 0 {
                print(bird.results[0].default_photo.medium_url)
                setImageData(imageURL: bird.results[0].default_photo.medium_url)
            }
        })
    }
    
}

struct BirdInfo_Previews: PreviewProvider {
    static var previews: some View {
        BirdInfo(name: .constant("Haliaeetus leucocephalus"))
    }
}
