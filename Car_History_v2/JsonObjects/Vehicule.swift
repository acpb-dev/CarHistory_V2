//
//  Vehicule.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import Foundation

struct Car: Codable, Hashable {
    var customName = String()
    var vin = String()
    var year = 0
    var manifacturer = String()
    var model = String()
    var color = String()
    var miles = 0
    var weight = 0
    var transmission = String()
    var drivetrain = String()
    var image = String()
    var dateAdded = Date()
    var modified = 0
    var maintenance = [MaintenanceItem]()
}

struct MaintenanceItem: Codable, Hashable {
    var date = Date()
    var name = String()
    var desctiption = String()
    var type = String()
    var miles = 0
}
