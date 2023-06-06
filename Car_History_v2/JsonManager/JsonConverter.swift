//
//  JsonConverter.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import Foundation

class JsonConverter {
    
    static func encode<T:Codable>(dateString: String?, printVal: Bool) -> T? {
        if dateString != nil {
            do {
                let jsonData = dateString!.data(using: .utf8)!
                let decoder = JSONDecoder()
                let myStruct: T = try decoder.decode(T.self, from: jsonData)
                return myStruct
            } catch {}
        }
        
        return nil
    }

    static func decode<T:Codable>(object: T) -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(object)
            let string = String(data: data, encoding: .utf8)
            return string
        } catch{}
        
        return nil
    }
}
