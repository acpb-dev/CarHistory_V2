//
//  ContentView.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var controller = CarController()
    @State var carsStored = [Car]()
    var body: some View {
        NavigationStack {
            List {
                ForEach(carsStored, id: \.self) { car in
                    VehicleView(vin: car.vin, controller: controller)
                }
            }
            .onAppear {
                carsStored = controller.GetAllCars()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button{
                        withAnimation{
                            controller.listSort.toggle()
                            carsStored = controller.GetAllCars()
                        }
                    } label: {
                        if controller.listSort {
                            Image(systemName: "clock.arrow.circlepath")
                            
                        } else {
                            Image(systemName: "textformat")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button{
                        withAnimation{
                            controller.showAddVehicle.toggle()
                        }
                    } label: {
                        Image(systemName: "plus")
                        
                    }
                    .sheet(isPresented: $controller.showAddVehicle) {
                        carsStored = controller.GetAllCars()
                    } content: {
                        AddVehicleView(controller: controller)
                            .preferredColorScheme(.dark)
                    }
                }
                ToolbarItem(placement: .principal){
                    Text("Vehicles")
                        .font(.title)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
