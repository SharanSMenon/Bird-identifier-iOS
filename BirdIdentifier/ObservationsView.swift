//
//  ObservationsView.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/22/21.
//

import SwiftUI

struct ObservationsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject var birdData = ReadData()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.id) { item in
                    NavigationLink(destination:ObservationItemView(observation: item)
                                    .navigationTitle(birdData.getInfo(scientific: item.scientific!).common)) {
                        VStack(alignment:.leading) {
                            HStack {
                                Text(birdData.getInfo(scientific: item.scientific!).common)
                                    .font(.title3)
                                Spacer()
                            }
                            HStack {
                                Text("\(dateFormatter.string(from: item.timestamp!))")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                    .background(
                        colorScheme == .light ? Color(red: 238/255, green:238/255, blue: 238/255) : Color(red: 39/255, green:39/255, blue: 39/255)
                    )
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .onDelete(perform: deleteItem)
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Your Observations")
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        print(offsets)
        for offset in offsets {
            let item = items[offset]
            viewContext.delete(item)
        }
        try! viewContext.save()
        
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    //    formatter.dateFormat = "EEE, MMM dd, yyyy 'at' h:MM a"
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

struct ObservationsView_Previews: PreviewProvider {
    static var previews: some View {
        ObservationsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
