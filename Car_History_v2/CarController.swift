//
//  CarController.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import Foundation
import UIKit
import PhotosUI

@MainActor
class CarController: ObservableObject {
    var jsonConverter: JsonConverter
    var fileReadWriter: FileReadWriter
    var fetchController: FetchController
    var carsStored = [Car]()
    
    @Published var showAddVehicle = false
    @Published var showAddMaintenance = false
    @Published var listSort = true
    @Published var carFound = false
    @Published var updated = false
    @Published var searchedCar = Car()
    
    init() {
        jsonConverter = JsonConverter()
        fileReadWriter = FileReadWriter()
        fetchController = FetchController()
        _ = GetAllCars()
    }
    
    public func GetAllCars() -> [Car] {
        var carsFound = [Car]()
        let allFiles = fileReadWriter.getAllSavedVehicles()
        for file in allFiles {
            let result = GetVehicleInfo(fileName: file)
            if result != nil {
                carsFound.append(result!)
            }
        }
        carsStored.removeAll()
        if(listSort){
            carsStored = carsFound.sorted { $0.year > $1.year }
        }else{
            carsStored = carsFound.sorted { $0.manifacturer > $1.manifacturer }
        }
        return carsStored
    }
    
    public func DoesCarExist(vin: String) -> Bool{
        let car = GetVehicleInfo(fileName: vin)
        
        if car != nil{
            return true
        }
        
        return false
    }
    
    public func ClearSearchedCar() {
        showAddVehicle = false
        searchedCar = Car()
        carFound = false
    }
    
    public func GetAllVehicule() -> [String] {
        return fileReadWriter.getAllSavedVehicles()
    }
    
    public func GetVehicleInfo(fileName: String) -> Car? {
        let fileString = fileReadWriter.readFile(fileName: String("cars/\(fileName)"))
        return JsonConverter.encode(dateString: fileString, printVal: false)
    }
    
    public func SaveVehicleInfo(carInfo: Car) {
        let stringObject = JsonConverter.decode(object: carInfo)
        fileReadWriter.writeFile(fileName: String("cars/\(carInfo.vin)"), content: stringObject, extensionType: ".json")
    }
    
    public func SaveImage(image: UIImage?, vin: String){
        _ = fileReadWriter.writeImage(imageImported: image, fileName: vin)
    }
    
    public func GetImage(imageLink: String) -> UIImage? {
        let image = fileReadWriter.getSavedImage(fileName: imageLink)
        return image
    }
    
    public func deleteCar(vin: String) {
        _ = fileReadWriter.deleteCar(fileName: vin)
        
    }
    
    public func DeleteImage(vin: String) -> Bool {
        return fileReadWriter.deleteImage(fileName: vin)
    }
    
    public func addMaintenanceItem(carNew: Car, item: MaintenanceItem) {
        var newCar = carNew
        newCar.maintenance.append(item)
        SaveVehicleInfo(carInfo: newCar)
    }
    
    public func FindVehicleByVin(vin: String) {
        Task {
            do {
                let tempCar = try await fetchController.getCar(vin: vin)
                carFound = CreateSanitizedObject(carInfo: tempCar)
            } catch{
                print(error)
            }
        }
    }
    
    private func CreateSanitizedObject(carInfo: VehicleSearch?) -> Bool {
        if carInfo?.Results == nil {
            return false
        }
        var car = Car()
        car.vin = String(carInfo!.SearchCriteria.dropFirst(4))
        
        for item in carInfo!.Results {
            if "Make".compare(item.Variable, options: .caseInsensitive) == .orderedSame{
                car.manifacturer = item.Value ?? String()
            }
            
            if "Model".compare(item.Variable, options: .caseInsensitive) == .orderedSame{
                car.model = item.Value ?? String()
            }
            
            if "Model Year".compare(item.Variable, options: .caseInsensitive) == .orderedSame{
                car.year = Int(item.Value ?? "0") ?? 0
            }
            
            if "Transmission Style".compare(item.Variable, options: .caseInsensitive) == .orderedSame{
                car.transmission = item.Value ?? String()
            }
        }
        searchedCar = car
        print(searchedCar.model)
        return true
    }
}
