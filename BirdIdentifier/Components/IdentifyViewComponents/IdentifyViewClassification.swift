//
//  IdentifyViewClassification.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/22/21.
//

import SwiftUI

struct IdentifyViewClassification: View {
    var classification: String
    var displayName: String
    var predictionList: [String]
    @Binding var showInfoSheet: Bool;
    @State var showPredictionsSheet: Bool = false
    var body: some View {
        Group {
            VStack(alignment:.leading) {
                VStack {
                    if classification == "background" {
                        Text("Unable to Classify")
                            .padding(10)
                            .foregroundColor(Color.black)
                            .shadow(radius: 5)
                            .background(
                                Color(red: 238/255,
                                      green:238/255, blue: 238/255)
                            )
                            .opacity(1)
                            .cornerRadius(20)
                    } else {
                        Button(action: {
                            self.showInfoSheet = true
                        }) {
                            VStack(alignment:.leading) {
                                HStack {
                                    Text("\(displayName) \(Image(systemName: "chevron.right"))")
                                        .bold()
                                        .foregroundColor(Color.black)
                                    Spacer()
                                }
                                Text("\(classification)")
                                    .foregroundColor(Color.gray)
                            }
                            
                        }
                    }
                }
                Divider()
                Button(action: {
                    self.showPredictionsSheet = true
                    print(predictionList);
                }) {
                    Text("View more predictions")
                }
                .sheet(isPresented:$showPredictionsSheet) {
                    PredictionList(predictions:predictionList)
                }
            }
            .padding()
            .background(
                Color(red: 238/255, green:238/255, blue: 238/255)
            )
            .cornerRadius(20)
            .frame(maxWidth:.infinity)
            .shadow(radius: 5)
        }
        .padding()
    }
}

struct IdentifyViewClassification_Previews: PreviewProvider {
    static var previews: some View {
        IdentifyViewClassification(classification: "Haliaeetus leucocephalus", displayName: "Bald Eagle", predictionList: ["Columba livia", "Columba livia domestica", "Corvus brachyrhynchos", "Corvus corax", "Corvus monedula"], showInfoSheet: .constant(false))
    }
}
