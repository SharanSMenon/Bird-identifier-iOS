//
//  SpeciesView.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/21/21.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct SpeciesView: View {
    @ObservedObject var birdData = ReadData()
    @State var filteredData: [Bird] = Array(ReadData().species)
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach (filteredData, id: \.id) { s in
                    NavigationLink(destination: {
                        NavigationLazyView(BirdInfo(name: .constant(s.scientific)))
                    }) {
                        Text("\(s.common)")
                    }
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) {searchText in
                if !searchText.isEmpty {
                    filteredData = birdData.species.filter {$0.common.localizedCaseInsensitiveContains(searchText.lowercased()) }
                } else {
                    filteredData=birdData.species
                }
            }
            .navigationTitle("All Species")
        }
    }
}

struct SpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        SpeciesView()
    }
}
