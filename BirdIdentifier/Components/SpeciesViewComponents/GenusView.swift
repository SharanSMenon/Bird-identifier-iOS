
//
//  GenusView.swift
//  BirdIdentifier
//  Shows all genuses in family specified by FamilyView
//  Created by Sharan Sajiv Menon on 12/4/21.
//

import SwiftUI

struct GenusView: View {
    @ObservedObject var birdData = ReadData()
    var family: String
    
    var body: some View {
        List {
            ForEach (getGenuses(), id:\.self) { genus in
                NavigationLink(
                    destination: NavigationLazyView(BirdListView(birdData: getGenusSpecies(genus: genus)))
                        .navigationTitle(genus)
                ) {
                    Text(genus)
                }
            }
        }
    }
    
    func getGenuses() -> [String] {
        return birdData.getGenusInFamily(family: family)
    }
    
    func getGenusSpecies(genus: String) -> [Bird] {
        return birdData.getGenus(genus: genus);
    }
}

struct GenusView_Previews: PreviewProvider {
    static var previews: some View {
        GenusView(family: "Corvidae")
    }
}
