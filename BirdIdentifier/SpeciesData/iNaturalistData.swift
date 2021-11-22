//
//  iNaturalistData.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/21/21.
//

import Foundation
import SwiftUI

struct DefaultPhoto: Decodable {
    let id: Int
    let attribution: String?
    let license_code: String?
    let url: String
    let medium_url: String
    let square_url: String?
}

struct Place: Decodable {
    let id: Int
    let name: String
    let display_name: String
}

struct iNatResult: Decodable {
    let id: Int
    let iconic_taxon_id: Int?
    let iconic_taxon_name: String?
    let is_active: Bool?
    let name: String?
    let preferred_common_name: String?
    let rank: String?
    let rank_level: Int?
    let default_photo: DefaultPhoto
    let colors: [Color?]?
    let conservation_status: ConservationStatus?
    let conservation_statuses: [ConservationStatuses?]?
    let observations_count: Int?
    let preferred_establishment_means: String?
    let establishment_means: EstablishmentMeans?
    
    struct EstablishmentMeans: Decodable {
        let establishment_means: String?
        let place: Place?
        
    }
    
    struct ConservationStatuses: Decodable {
        let source_id: Int?
        let authority: String?
        let status: String?
        let status_name: String?
        let iucn: Int?
        let geoprivacy: String?
        let place: Place?
    }
    
    struct ConservationStatus: Decodable {
        let place_id: Int?
        let place: Place?
        let status: String?
    
    }
    
    struct Color: Decodable {
        let id: Int?
        let value: String?
    }
    
}

struct iNatResponse: Decodable {
    let total_results: Int?
    let page: Int?
    let per_page: Int?
    let results: [iNatResult]
}
