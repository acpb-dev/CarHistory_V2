//
//  VehicleInfoView.swift
//  Car_History_v2
//
//  Created by Will Bergeron on 4/12/23.
//

import SwiftUI
import PhotosUI

struct VehicleInfoView: View {
    @Environment(\.dismiss) private var dismiss
    let vin: String
    @ObservedObject var controller: CarController
    @State private var showAlert = false
    @State var name = String()
    @State var car = Car()
    var body: some View {
        NavigationView {
            List {
                HStack(alignment: .center){
                    VStack(alignment: .leading){
                        Text("\(String(car.year)) \(car.manifacturer) \(car.model)")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        
                        Text("aka:")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        VStack (alignment: .center){
                           
                            TextField(name, text: $name)
                                .foregroundColor(.blue)
                                .onAppear {
                                    name = car.customName
                                }
                                .onSubmit {
                                    car.customName = name
                                    controller.SaveVehicleInfo(carInfo: car)
                                }
                                .disableAutocorrection(true)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .placeholder(when: car.customName.isEmpty && name.isEmpty) {
                                    Text("Nickname").foregroundColor(.gray).frame(maxWidth: .infinity).multilineTextAlignment(.center)
                                }
                        }
                        .multilineTextAlignment(.center)
                    }
                    .frame(width: UIScreen.main.bounds.width/2.5)
                    .padding()
                    
                    VStack(alignment: .center){
                        Image(uiImage: controller.GetImage(imageLink: vin) ?? UIImage(named: "placeholder") ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .overlay(OverlayEdit(vin: vin, controller: controller))
                    }
                    .clipShape(Circle())
                    .padding()
                    .frame(width: UIScreen.main.bounds.width/2.5)
                }
                .frame(width: UIScreen.main.bounds.width)
                
                ForEach(car.maintenance.sorted { $0.miles > $1.miles }, id: \.self) { maintenanceItem in
                    Section() {
                        VStack(alignment: .center) {
                            Text(maintenanceItem.name)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .padding(10)
                            Divider()
                            VStack(alignment: .center){
                                Text("Description:")
                                    .font(.title3)
                                Text("\(maintenanceItem.desctiption)")
                                    .foregroundColor(.gray)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)

                            VStack(alignment: .center){
                                Text("Miles:")
                                    .font(.title3)
                                Text("\(maintenanceItem.miles)")
                                    .foregroundColor(.gray)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)

                            VStack(alignment: .center){
                                Text("Date:")
                                    .font(.title3)
                                Text("\(maintenanceItem.date.getFormattedDate(format: "yyyy-MM-dd"))")
                                    .foregroundColor(.gray)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                        }
                    }
                }
            }
//            .id(UUID())
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete car?"),
                    message: Text("Are you sure you want to delete the \(String(car.year)) \(car.manifacturer) \(car.model) ?"),
                    primaryButton: .destructive(
                        Text("Delete")){
                            controller.deleteCar(vin: car.vin)
                            dismiss()
                        },
                    secondaryButton: .default(
                        Text("Cancel")){
                            showAlert = false
                        }
                )
            }
        }
        .onAppear{
            car = controller.GetVehicleInfo(fileName: vin + ".json") ?? Car()
        }
        .navigationBarItems(trailing:
        HStack{
            Button{
                withAnimation{
                    controller.showAddMaintenance.toggle()
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $controller.showAddMaintenance) {
                print("end")
                car = controller.GetVehicleInfo(fileName: vin + ".json") ?? Car()
            } content: {
                AddMaintenanceView(vin: car.vin, controller: controller)
                    .preferredColorScheme(.dark)
            }
            Menu {
                Button("VIN: \(car.vin)"){ UIPasteboard.general.string = car.vin }
                Button("YEAR: \(String(car.year))"){ UIPasteboard.general.string = String(car.year) }
                Button("BRAND: \(car.manifacturer)"){ UIPasteboard.general.string = car.manifacturer }
                Button("MODEL: \(car.model)"){ UIPasteboard.general.string = car.model }
                Button("COLOR: \(car.color)"){ UIPasteboard.general.string = String(car.color) }
                Button("MILES: \(car.miles)km"){ UIPasteboard.general.string = String(car.vin) }
                Button("TRANSMISSION: \(car.transmission)"){ UIPasteboard.general.string = String(car.transmission) }
                Button("Delete", role: .destructive) { showAlert = true }
            }
        label: {
            Text("Info")
                .foregroundColor(.gray)
        }})
        .foregroundColor(.white)
    }
}

struct OverlayEdit: View {
    let vin: String
    var controller: CarController
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    var body: some View {
        Spacer()
        var car = controller.GetVehicleInfo(fileName: vin + ".json") ?? Car()
        VStack(alignment: .center) {
            
            PhotosPicker(selection: $avatarItem, matching: .images, photoLibrary: .shared()) { Text("Edit") }
                .buttonStyle(.borderless)
                .foregroundColor(.blue)
                .font(.title3)
                .onChange(of: avatarItem) { _ in
                    Task {
                        if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                avatarImage = uiImage
                                controller.SaveImage(image: avatarImage, vin: car.vin)
                                car.modified += 1
                                controller.updated.toggle()
                                controller.SaveVehicleInfo(carInfo: car)
                                return
                            }
                        }
                    }
                }
                .frame(width: 200)
                .background(Color.black)
        }
        .opacity(0.8)
        .cornerRadius(10.0)
        .frame(height: 150)
        .padding(.top, 80)
    }
}

struct VehicleInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleInfoView(vin: "wvwhv7aj8cw294639", controller: CarController())
            .preferredColorScheme(.dark)
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
