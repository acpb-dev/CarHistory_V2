//
//  FileReadWriter.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import Foundation
import UIKit

class FileReadWriter {
    
    var filesUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func getAllSavedVehicles() -> [String]{
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("cars")
        do {
            let filesFound = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            var listVins = [String]()
            for file in filesFound {
//                print(file.absoluteString)
                listVins.append(String(file.lastPathComponent))
            }
            return listVins
        } catch {
            do {
                try fileManager.createDirectory(atPath: documentsURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch _ as NSError {}
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return [String]()
    }
    
    func writeFile(fileName: String, content: String?, extensionType: String) {
        do {
            verifyCarsFolderExists()
            if content != nil {
                try content!.write(to: filesUrl.appendingPathComponent("\(fileName)\(extensionType)"), atomically: false, encoding: .utf8)
            }
            
        }
        catch {
            print("FailedWrite")
        }
    }
    
    func verifyCarsFolderExists() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let carsDirectory = documentsDirectory.appendingPathComponent("cars")

        if !fileManager.fileExists(atPath: carsDirectory.path) {
            do {
                try fileManager.createDirectory(atPath: carsDirectory.path, withIntermediateDirectories: true, attributes: nil)
//                print("Folder 'cars' created successfully")
            } catch {
//                print("Error creating folder 'cars': \(error.localizedDescription)")
            }
        } else {
//            print("Folder 'cars' already exists")
        }
    }
    
    func writeImage(imageImported: UIImage?, fileName: String) -> String {
        if let image = imageImported {
            if let data = image.jpegData(compressionQuality: 0.5) {
                let filename = filesUrl.appendingPathComponent("\(fileName.uppercased()).jpg")
                try? data.write(to: filename)
//                print(filesUrl.appendingPathComponent("\(fileName).png").absoluteString)
                return fileName
            }
        }
        return String()
    }
    
    func getSavedImage(fileName: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("\(fileName.uppercased()).jpg").path)
        }
        return nil
    }
    
    func deleteImage(fileName: String) -> Bool {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let fileURL = dir.appendingPathComponent("\(fileName.uppercased()).jpg")
            do {
                try FileManager.default.removeItem(at: fileURL)
                return true
            } catch {
                print("Error deleting file: \(error.localizedDescription)")
            }
        }
        return false
    }

    
    func deleteCar(fileName: String) -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!.appendingPathComponent("cars")
        do {
            let filesFound = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
    
            for file in filesFound {
                if "\(fileName).json".compare(file.lastPathComponent, options: .caseInsensitive) == .orderedSame{
                    try fileManager.removeItem(at: file)
                    _ = getAllSavedVehicles()
                    return true
                }
            }
        } catch {
            print("failed")
        }
        return false
    }
    
    func readFile(fileName: String) -> String? {
        do {
            return try String(contentsOf: filesUrl.appendingPathComponent("\(fileName)"), encoding: .utf8)
        }
        catch {print("failed read \(fileName)")}
        return nil
    }
    
    
    func listAllCars(){
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!
        do {
            let filesFound = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            var listVins = [String]()
            for file in filesFound {
                print(file.absoluteString)
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
}

