
import SwiftUI
import Combine
import PhotosUI

struct AddVehicleView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    @State private var showAlert = false
    @ObservedObject var controller: CarController
    var inputNum = String()
    var body: some View {
        VStack(alignment: .center) {
            TextField("VIN", text: $controller.searchedCar.vin).foregroundColor(.white)
            .disableAutocorrection(true)
            .disabled(controller.carFound)
            .background(RoundedRectangle(cornerRadius: 10).fill(.white))
            .foregroundColor(.black)
            
            if controller.carFound {
                
                VStack(alignment: .center) {
                    HStack(alignment: .top){
                        VStack(alignment: .leading){
                            Text("Manifacturer")
                                .padding(.top, 10)
                            TextField(
                                "Manifacturer",
                                text: $controller.searchedCar.manifacturer
                            )
                            .disableAutocorrection(true)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Model")
                                .padding(.top, 10)
                            TextField(
                                "Model",
                                text: $controller.searchedCar.model
                            )
                            .disableAutocorrection(true)
                        }
                    }
                    
                    
                    HStack(alignment: .top){
                        
                        VStack(alignment: .leading){
                            Text("Year")
                                .padding(.top, 10)
                            TextField("Year", value: $controller.searchedCar.year, formatter: NumberFormatter())
                            .disableAutocorrection(true)
                            .keyboardType(.numberPad)
                            .onReceive(Just(controller.searchedCar.year)) { newValue in
                                let filtered = String(newValue).filter { "0123456789".contains($0) }
                                if filtered != String(newValue) {
                                    controller.searchedCar.year = Int(filtered) ?? 0
                                }
                            }
                        }
                        
                        
                        VStack(alignment: .leading){
                            Text("Miles")
                                .padding(.top, 10)
                            TextField("miles", value: $controller.searchedCar.miles, formatter: NumberFormatter())
                            .disableAutocorrection(true)
                            .keyboardType(.numberPad)
                            .onReceive(Just(controller.searchedCar.miles)) { newValue in
                                let filtered = String(newValue).filter { "0123456789".contains($0) }
                                if filtered != String(newValue) {
                                    controller.searchedCar.miles = Int(filtered) ?? 0
                                }
                            }
                        }
                    }
                }
                
                VStack {
                    PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
                }
                .onChange(of: avatarItem) { _ in
                    Task {
                        if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                avatarImage = uiImage
                                return
                            }
                        }
                        print("Failed")
                    }
                }
                
                Button{
                    // Add car
                    if let avatarImage {
                        controller.SaveImage(image: avatarImage, vin: controller.searchedCar.vin)
                    }
                    
                    if controller.DoesCarExist(vin: controller.searchedCar.vin + ".json") {
                        showAlert = true
                    }else {
                        controller.SaveVehicleInfo(carInfo: controller.searchedCar)
                        controller.ClearSearchedCar()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }
                label: {
                    Text("Add Vehicle")
                        .padding(10)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Unable to Add Vehicle."),
                        message: Text("The vin you've entered already exists in your list. Do you want to replace it? Replacing it will delete the maintenance items."),
                        primaryButton: .default(
                            Text("Don't Replace")){
                                print("dont replace")
                                controller.showAddVehicle = false
                                self.presentationMode.wrappedValue.dismiss()
                            },
                        secondaryButton: .destructive(
                            Text("Replace")){
                                print("replace")
                                controller.SaveVehicleInfo(carInfo: controller.searchedCar)
                                controller.ClearSearchedCar()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                    )
                }
            
            }else{
                Button{
                    controller.FindVehicleByVin(vin: controller.searchedCar.vin)
                }
                label: {
                    Text("Find")
                        .padding(10)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())

                }
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
}

struct AddVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        AddVehicleView(controller: CarController())
            .preferredColorScheme(.dark)
    }
}
