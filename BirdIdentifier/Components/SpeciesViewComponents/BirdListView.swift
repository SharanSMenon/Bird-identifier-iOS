//
//  BirdListView.swift
//  BirdIdentifier
//
//  Shows just the species list. Family, order, and genus are in different components
//
//  Created by Sharan Sajiv Menon on 12/4/21.
//

import SwiftUI

struct BirdListView: View {
    var birdData: [Bird]
    
    var body: some View {
        List {
            ForEach (birdData, id: \.id) { s in
                NavigationLink(destination: {
                    NavigationLazyView(BirdInfo(name: .constant(s.scientific)))
                        .navigationBarTitle(s.common)
                }) {
                    Text("\(s.common)")
                }
            }
        }
//        .searchable(text: $searchText)
//        .onChange(of: searchText) {searchText in
//            if !searchText.isEmpty {
//                filteredData = birdData.species.filter {$0.common.localizedCaseInsensitiveContains(searchText.lowercased()) }
//            } else {
//                filteredData=birdData.species
//            }
//        }
    }
}

struct BirdListView_Previews: PreviewProvider {
    
    static var previews: some View {
        @ObservedObject var birdData = ReadData()
        @State var filteredData: [Bird] = Array(ReadData().species)
        
        return BirdListView(birdData: filteredData)
    }
}
