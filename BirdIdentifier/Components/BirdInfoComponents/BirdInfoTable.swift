//
//  BirdInfoTable.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/22/21.
//

import SwiftUI

struct BirdInfoTable: View {
    @Binding var birdInfo: Bird
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Text("Common Name")
                Divider()
                Text(birdInfo.common)
            }
            Divider()
            HStack {
                Text("Scientific Name")
                Divider()
                Text(birdInfo.scientific)
            }
            Divider()
            HStack {
                Text("Family")
                Divider()
                Text(birdInfo.family)
            }
            Divider()
            HStack {
                Text("Order")
                Divider()
                Text(birdInfo.order)
            }
        }
    }
}

struct BirdInfoTable_Previews: PreviewProvider {
    static var previews: some View {
        BirdInfoTable(birdInfo: .constant(ReadData().getInfo(scientific: "Haliaeetus leucocephalus")))
    }
}
