//
//  ObservationItemView.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/22/21.
//

import SwiftUI
import CoreData

struct ObservationItemView: View {
    @State var observation: Item
    @ObservedObject var birdData = ReadData()
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        ScrollView {
            VStack {
                if observation.image != nil {
                    ObservationImage(classification: getInfo().scientific,
                                     common: getInfo().common,
                                     image: UIImage(data: observation.image!)!)
                } else {
                    HStack {
                        Text(getInfo().common)
                            .bold()
                            .font(.title)
                        Spacer()
                    }
                    HStack {
                        Text(observation.scientific!)
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                }
                Spacer().frame(maxHeight:20)
                GroupBox(label:Label("Date", systemImage: "calendar")) {
                    HStack {
                        Text("\(dateFormatter.string(from: observation.timestamp!))")
                        Spacer()
                    }
                }
                .shadow(radius: 2)
                Group {
                    NavigationLink(
                        destination: BirdInfo(name: .constant(getInfo().scientific))
                            .navigationTitle(getInfo().common)
                    ) {
                        HStack {
                            VStack {
                                Text("Species Information Page")
                            }
                            Spacer()
                        }
                        .padding()
                        .background(colorScheme == .light ? Color(red: 238/255, green:238/255, blue: 238/255) : Color(red: 39/255, green:39/255, blue: 39/255))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .frame(maxWidth:screenSize.width)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            
        }
    }
    
    private func getInfo() -> Bird {
        return birdData.getInfo(scientific: self.observation.scientific!)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    //    formatter.dateFormat = "EEE, MMM dd, yyyy 'at' h:MM a"
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()


struct ObservationItemView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let item = Item(context: moc)
        item.scientific = "Merops apiaster"
        item.timestamp = Date()
        return ObservationItemView(observation:item)
    }
}
