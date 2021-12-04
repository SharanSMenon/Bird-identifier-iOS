//
//  BirdSpecies.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/21/21.
//

import Foundation

struct Bird: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case scientific
        case common
        case family
        case order
        case genus
    }
    
    var id = UUID()
    var scientific: String
    var common: String
    var family: String
    var order: String
    var genus: String
}

class ReadData: ObservableObject {
    @Published var species =  [Bird]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource:"bird_info.json", withExtension: nil) else {
            print("Species Data not Found")
            return
        }
        let data = try? Data(contentsOf: url)
        let birds = try? JSONDecoder().decode([Bird].self, from: data!)
        self.species = birds!
    }
    
    func getInfo(scientific: String) -> Bird {
        for s in species {
            if s.scientific == scientific {
                return s
            }
        }
        return species[0]
    }
    
    func getGenus(genus: String, scientific: String) -> [Bird] {
        return Array(species.filter {($0.genus == genus) && ($0.scientific != scientific)})
    }
    
    func getGenus(genus: String) -> [Bird] {
        return Array(species.filter {($0.genus == genus)})
    }
    
    func getFamily(family: String, scientific: String) -> [Bird] {
        return Array(species.filter {($0.family == family) && ($0.scientific != scientific)})
    }
    
    func getFamily(family: String) -> [Bird] {
        return Array(species.filter {($0.family == family)})
    }
    
    func getOrder(order: String, scientific: String) -> [Bird] {
        return Array(species.filter {($0.order == order) && ($0.scientific != scientific)})
    }
    
    func getOrder(order: String) -> [Bird] {
        return Array(species.filter {($0.order == order)})
    }
    
    func getAllOrders() -> [String] {
        return Array(Set(species.map {$0.order}))
    }
    
    func getFamiliesInOrder(order: String) -> [String] {
        let orderSpecies: [Bird] = Array(species.filter {$0.order == order})
        return Array(Set(orderSpecies.map {$0.family}))
    }
    
    func getGenusInFamily(family: String) -> [String] {
        let familySpecies: [Bird] = Array(species.filter {$0.family == family})
        return Array(Set(familySpecies.map {$0.genus}))
    }
    
    func getMock() -> [Bird] {
        return Array(species[0...5])
    }
}
