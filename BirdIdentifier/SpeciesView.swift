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

enum ViewType: String, CaseIterable, Identifiable {
    case Tree
    case List
    
    var id: String { self.rawValue }
}

struct SpeciesView: View {
    @ObservedObject var birdData = ReadData()
    @State var filteredData: [Bird] = Array(ReadData().species)
    @State private var searchText = "";
    @State var selectedView: ViewType  = ViewType.List;
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedView == ViewType.List {
                    List {
                        ForEach (filteredData, id: \.id) { s in
                            NavigationLink(destination: {
                                NavigationLazyView(BirdInfo(name: .constant(s.scientific)))
                                    .navigationBarTitle(s.common)
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
                } else if selectedView == ViewType.Tree {
                    OrderView()
                        .navigationTitle("Orders")
                }
            }
            .toolbar {
                Picker("View Type", selection: $selectedView) {
                    Text("List").tag(ViewType.List)
                    Text("Tree").tag(ViewType.Tree)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct SpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        SpeciesView()
    }
}
