//
//  VehiculeSearch.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import Foundation

struct VehicleSearch: Codable {
    let Count: Int
    let Message, SearchCriteria: String
    let Results: [Result]
}

struct Result: Codable {
    let Value, ValueID: String?
    let Variable: String
    let VariableId: Int
}
