//
//  FetchController.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import Foundation
import UIKit

actor FetchController {
    enum NetWorkError: Error {
        case badURL, badResponse
    }
    
    private let baseURL = URL(string: "https://vpic.nhtsa.dot.gov/api/")!
    
    func getCar(vin: String) async throws -> VehicleSearch? {
        let url = baseURL.appendingPathComponent("vehicles/DecodeVin/\(vin)")
        let request = getRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetWorkError.badResponse
        }
        let decoder = JSONDecoder()
        return try decoder.decode(VehicleSearch.self, from: data)
    }
    
    private func getRequest(url: URL, method: String) -> URLRequest{
        var newUrl = url
        newUrl.append(queryItems: [URLQueryItem(name: "format", value: "json")])
        var request = URLRequest(url: newUrl)
        request.httpMethod = method
        request.addValue("nLndSoQmZ+TV45i/mcTVVQ==vCeeSseZ0FMJAnGP", forHTTPHeaderField: "X-Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
