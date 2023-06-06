//
//  VehiculeView.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import SwiftUI
import PhotosUI

struct VehicleView: View {
    var vin: String
    var controller: CarController
    
    var body: some View {
        Section {
            NavigationLink(destination: VehicleInfoView(vin: vin, controller: controller)){}
                .listRowBackground(Image(uiImage: controller.GetImage(imageLink: vin) ?? UIImage(named: "placeholder") ?? UIImage()).centerCropped())
        }
        .frame(height: UIScreen.main.bounds.width/2.25)
        .overlay(ImageOverlay(vin: vin, controller: controller), alignment: .bottomTrailing)
        
    }
    
}

struct ImageOverlay: View {
    let vin: String
    var controller: CarController
    var body: some View {
        let car = controller.GetVehicleInfo(fileName: vin + ".json") ?? Car()
        ZStack(alignment: .bottomLeading) {
            HStack{
                VStack(alignment: .trailing) {
                    Text(car.customName.isEmpty ? "\(String(car.year)) \(car.manifacturer) \(car.model)" : car.customName  )
                        .font(.title2)
                    Text("\(car.miles)km")
                        .font(.caption)
                }
                .font(.callout)
                .padding(5)
                .foregroundColor(.white)
            }
            
        }.background(Color.black)
        .opacity(0.8)
        .cornerRadius(10.0)
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
        }
    }
}

struct VehicleView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleView(vin: "wvwhv7aj8cw294639", controller: CarController())
    }
}
