//
//  SearchedVinResult.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import Foundation

struct SearchedVinResult: Codable {
    var VIN = String()
    var Make = String()
    var Model = String()
    var Model_Year = String()
    var Transmission_Style = String()
    var Curb_Weight = String()
    var Drive_Type = String()
}
