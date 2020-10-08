//
//  AllMatchesModel.swift
//  Task
//
//  Created by Rohini Deo on 07/10/20.
//  Copyright © 2020 Taxgenie. All rights reserved.
//

import Foundation

struct AllMatchesModel:Decodable{
     let response : Venues
}

struct Venues:Decodable {
    let venues : [VenueDetails]
}

struct VenueDetails : Decodable{
    let id : String?
    let name : String?
    let contact : ContactDetails
    let location : LocationDetails
}

struct ContactDetails:Decodable {
    let phone : String?
}

struct LocationDetails:Decodable {
    let address : String?
    let country : String?
}

struct MatchedItem{
    var venuDetail : VenueDetails
    var isSelected : Bool
}
