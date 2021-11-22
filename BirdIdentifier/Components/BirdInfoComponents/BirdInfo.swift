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
