//
//  ContentView.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/18/21.
//

import UIKit
import SwiftUI
import CoreData
import CoreML
//import TensorFlowLite

struct ContentView: View {
    var body: some View {
        TabView {
            Identify()
            .tabItem {
                Label("Identify", systemImage: "camera.metering.spot")
            }
            SpeciesView()
                .tabItem {
                    Label("Species", systemImage: "list.dash")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 13 Pro Max").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
