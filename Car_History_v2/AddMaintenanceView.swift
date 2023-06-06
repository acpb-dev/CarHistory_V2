//
//  AddMaintenanceView.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/26/23.
//

import SwiftUI

struct AddMaintenanceView: View {
    let vin: String
    var controller: CarController
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var maintenanceItem = MaintenanceItem()
    let type = ["Maintenance", "Cosmetic", "Repair", "Performance", "Other"]
    @State private var typeSelection = "Maintenance"
    @State private var date = Date()
    
    var body: some View {
        var car = controller.GetVehicleInfo(fileName: vin + ".json") ?? Car()
        
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Text("Type of work: ")
                VStack(alignment: .leading) {
                    Picker("", selection: $maintenanceItem.type) {
                        ForEach(type, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .frame(width: UIScreen.main.bounds.width - 25)
            
            
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Name:")
                        .padding(.top, 10)
                    TextField(
                        "name",
                        text: $maintenanceItem.name
                    )
                    .disableAutocorrection(true)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text("Miles at: ")
                        .padding(.top, 10)
                    TextField("miles", value: $maintenanceItem.miles, formatter: NumberFormatter())
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .frame(width: UIScreen.main.bounds.width - 25)
            
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Description: ")
                        .padding(.top, 10)
                    TextField(
                        "description",
                        text: $maintenanceItem.desctiption,
                        axis: .vertical
                    )
                    .lineLimit(3)
                    .disableAutocorrection(true)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .frame(width: UIScreen.main.bounds.width - 25)
            
            HStack(alignment: .center) {
                DatePicker(selection: $maintenanceItem.date, in: ...Date.now, displayedComponents: .date) {
                    Text("Date of maintenance: ")
                }
            }
            .frame(width: UIScreen.main.bounds.width - 25)
        }
        .textFieldStyle(.roundedBorder)
        .onAppear{
//            controller.showAddMaintenance.toggle()
        }
        
        Button{
            // save maintenance
            controller.addMaintenanceItem(carNew: car, item: maintenanceItem)
            controller.showAddMaintenance.toggle()
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Add Item")
                .padding(10)
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            
        }
        
        
        
        
        
        
    }
}

struct AddMaintenanceView_Previews: PreviewProvider {
    static var previews: some View {
        AddMaintenanceView(vin: "df", controller: CarController())
    }
}
