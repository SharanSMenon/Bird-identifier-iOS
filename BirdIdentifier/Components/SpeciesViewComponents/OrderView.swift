//
//  OrderView.swift
//  BirdIdentifier
//  Top level view of the species tree.
//  Created by Sharan Sajiv Menon on 12/4/21.
//

import SwiftUI

struct OrderView: View {
    @ObservedObject var birdData = ReadData()
    var orders: [String] = ReadData().getAllOrders();
    
    var body: some View {
        List {
            ForEach (orders, id: \.self) { order in
                NavigationLink(
                    destination: NavigationLazyView(FamilyView(order: order))
                        .navigationTitle(order)
                ) {
                    Text(order)
                }
            }
        }
    }
    
    func getFamilies(order: String) -> [Bird] {
        return birdData.getOrder(order: order)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
