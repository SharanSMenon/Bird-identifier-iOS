//
//  SaveObservationButton.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/22/21.
//

import SwiftUI

struct SaveObservationButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var observedImage: UIImage
    @Binding var name: String
    @Binding var saved: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                if !saved {
                    saved = true
                    addItem()
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                }
            }) {
                Text(saved ? "Saved!" : "Save Observation")
                    .foregroundColor(Color.black)
            }
            .padding(10)
            .background(
                Color(red: 238/255, green:238/255, blue: 238/255)
            )
            .cornerRadius(20)
            .shadow(radius: 5)
        }
        .padding()
    }
    
    private func addItem() {
        withAnimation {
            let newItem: Item = Item(context: viewContext)
            let timestamp: Date = Date()
            newItem.timestamp = timestamp
            newItem.scientific = self.name
            let data = observedImage.jpegData(compressionQuality: 1.0)
            newItem.image = data
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//struct SaveObservationButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SaveObservationButton()
//    }
//}
