//
//  BirdInfoSimilarSpecies.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/22/21.
//

import SwiftUI

struct BirdInfoSimilarSpecies: View {
    @State var similarSpecies: [Bird]
    var body: some View {
        VStack {
            HStack {
                Text("Similar Species")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding()
            HStack {
                VStack (alignment:.leading) {
                    ForEach (similarSpecies, id: \.scientific) { s in
                        NavigationLink(destination: {
                            NavigationLazyView(BirdInfo(name: .constant(s.scientific)))
                                .navigationTitle(s.common)
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
    }
}

struct BirdInfoSimilarSpecies_Previews: PreviewProvider {
    static var previews: some View {
        BirdInfoSimilarSpecies(similarSpecies: ReadData().getGenus(genus: "Haliaeetus", scientific: "Haliaeetus leucocephalus"))
    }
}
