//
//  PredictionList.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 12/9/21.
//

import SwiftUI

struct PredictionList: View {
    @State var predictions: [String];
    @ObservedObject var birdData = ReadData()
    
    var body: some View {
        NavigationView {
            HStack {
                VStack(alignment:.leading) {
                    ForEach(predictions, id:\.self) { s in
                        PredictionListRow(scientificName: s)
                    }
                    Spacer()
                }
                .navigationTitle("All Predictions")
                Spacer()
            }
            .padding()
        }
    }
    
}

struct PredictionList_Previews: PreviewProvider {
    static var previews: some View {
        PredictionList(predictions: ["Columba livia", "Corvus brachyrhynchos", "Corvus corax", "Corvus monedula"])
    }
}
