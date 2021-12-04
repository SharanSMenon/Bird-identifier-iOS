//
//  FamilyView.swift
//  BirdIdentifier
//  Shows all bird families in specified order from OrderView
//  Created by Sharan Sajiv Menon on 12/4/21.
//

import SwiftUI

struct FamilyView: View {
    @ObservedObject var birdData = ReadData()
    var order: String
    
    var body: some View {
        List {
            ForEach (getFamilies(), id:\.self) { family in
                NavigationLink(
                    destination: NavigationLazyView(GenusView(family: family))
                        .navigationTitle(family)
                ) {
                    Text(family)
                }
            }
        }
    }
    
    func getFamilies() -> [String] {
        return birdData.getFamiliesInOrder(order: order)
    }
}

struct FamilyView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyView(order: "Passeriformes")
    }
}
