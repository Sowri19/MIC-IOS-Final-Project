//
//  NavigationBarComedyClubView.swift
//  MIC
//
//  Created by Sowri on 4/24/23.
//

import SwiftUI
import FirebaseAuth
import Firebase
import UIKit

struct ClubImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ClubImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ClubImagePicker>) {
        
    }
    
    func makeCoordinator() -> ClubImagePicker.Coordinator {
        return ImagePickerCoordinator(selectedImage: $selectedImage, presentationMode: presentationMode)
    }
    
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?
        let presentationMode: Binding<PresentationMode>
        
        init(selectedImage: Binding<UIImage?>, presentationMode: Binding<PresentationMode>) {
            _selectedImage = selectedImage
            self.presentationMode = presentationMode
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
            }
            selectedImage = uiImage
            presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct NavigationBarComedyClubView: View {
    // MARK: - PROPERTIES
    // MARK: - PROPERTIES
    
    @State private var isAnimated: Bool = false
    @AppStorage("uid") var userID: String = ""
    @State private var ClubProfileView: Bool = false // New state variable
    
    // MARK: - BODY

    var body: some View {
        HStack{
            LogoView()
                .opacity(isAnimated ? 1 : 0)
                .offset(x: 0, y: isAnimated ? 0 : -25)
                .onAppear(perform: {
                    withAnimation(.easeOut(duration: 0.5)){
                        isAnimated.toggle()
                    }
                })
            Button(action: {}, label:{
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundColor(.black)
            }) //: Button

            Spacer()
            Button(action: {
                let firebaseAuth = Auth.auth()
                do {
                  try firebaseAuth.signOut()
                  withAnimation{
                      userID = ""
                  }
                } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError)
                }
              }){
                Text("Logout")
                  .foregroundColor(.white)
                  .padding(.horizontal, 10)
                  .padding(.vertical, 5)
                  .background(Color.red)
                  .cornerRadius(10)
                  .frame(width: 90, height: 30)
              }
            
            Button(action: {
                            ClubProfileView = true // Set the state variable to true to show the view
                        }, label:{
                            ZStack {
                                Image(systemName: "person.circle")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                        }) //: Button
                    }
                    .sheet(isPresented: $ClubProfileView) {
                        // Present the ProfileView modally
                        ComClubProfileView()
                    }
                }
}

struct ComClubProfileView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var Location: String = ""
    @State var PointOfContact: String = ""
    
    @State private var location: String = ""
    @State var pointOfContact: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false


    @AppStorage("uid") var userID: String = ""

    func fetchUserData(completion: @escaping (String?, Error?) -> Void) {
        
        do {
            guard let url = URL(string: "http://localhost:8080/users/get/\(userID)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let jsonString = ""
//            request.httpBody = jsonString.data(using: .utf8)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request){ data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        let responseData = String(data: data, encoding: .utf8)!
                        DispatchQueue.main.async {
//                            alertMessage = responseData
//                            showAlert = true
                            completion(responseData, nil)
                        }
                    } else {
                        print("Server Error: \(httpResponse.statusCode)")
                    }
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                HStack{
                    Text("Welcome ")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    + Text(firstName)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green) +
                    Text("!!\nYour Profile")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()

                    Spacer()
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    }
                }
                .padding()
                .padding(.top)
                .onAppear {
                    fetchUserData { (data, error) in
                        if let data = data?.data(using: .utf8) {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    firstName = json["firstName"] as? String ?? ""
                                    lastName = json["lastName"] as? String ?? ""
                                    Location = json["location"] as? String ?? ""
                                    PointOfContact = json["poc"] as? String ?? ""
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else if let error = error {
                            // Handle the error
                        }
                    }
                }
                    //  Fetched Comedy Club View from the database
                ScrollView(.vertical, showsIndicators: false, content:{
                    VStack{
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 20)], spacing: 20) {
                            Text("First Name:")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextEditor(text: $firstName)
                                .padding(.horizontal, 10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .disabled(true)
                                .frame(minHeight: 35)
                            
                            Text("Last Name:")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextEditor(text: $lastName)
                                .padding(.horizontal, 10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .disabled(true)
                                .frame(minHeight: 35)
                            
                            Text("Point of Contact:")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextEditor(text: $PointOfContact)
                                .padding(.horizontal, 10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .disabled(true)
                                .frame(minHeight: 35)
                            
                            Text("Location:")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextEditor(text: $Location)
                                .padding(.horizontal, 10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .disabled(true)
                            .frame(minHeight: 35)
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding()
                })
                               
                HStack {
//                    Text("First Name: " + firstName)
                    Image(systemName: "person")
                    TextField("Write your Point of Contact", text: $pointOfContact)
                        
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                
                HStack {
//                    Text("First Name: " + firstName)
                    Image(systemName: "mappin.and.ellipse")
                    TextField("Location", text: $location)
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                
                HStack{
                    Button(action: {
                        self.showImagePicker = true
                    }){
                        Text("Select Image")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white))
                        .padding(.horizontal)
                        
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                }
                Spacer()
                Button{
                    
                    let imageData = selectedImage?.pngData()
                    let base64ImageString = imageData?.base64EncodedString(options: .lineLength64Characters)
                                                            
                    do {
                        let body = [
                            "id": userID,
                            "poc": pointOfContact,
                            "location": location,
                            "picture": base64ImageString ?? ""
                        ] as [String : Any]
                        let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                        let jsonString = String(data: jsonData, encoding: .utf8)!
                        print(jsonString)
                        guard let url = URL(string: "http://localhost:8080/users/update") else {
                            return
                        }
                                                                                    
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                                                                    
                        request.httpBody = jsonString.data(using: .utf8)
                                                                                    
                        let session = URLSession.shared
                                                                                    
                        let task = session.dataTask(with: request){ data, response, error in
                        guard let data = data, error == nil else {
                            print(error?.localizedDescription ?? "Unknown error")
                            return
                        }
                        if let httpResponse = response as? HTTPURLResponse {
                            if (200...299).contains(httpResponse.statusCode) {
                                let responseData = String(data: data, encoding: .utf8)!
                                DispatchQueue.main.async {
                                    alertMessage = responseData
                                    showAlert = true
                                }
                            } else {
                            print("Server Error: \(httpResponse.statusCode)")
                            }
                        }
                    }
                    task.resume()
                    
                    fetchUserData { (data, error) in
                        if let data = data?.data(using: .utf8) {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    firstName = json["firstName"] as? String ?? ""
                                    lastName = json["lastName"] as? String ?? ""
                                    Location = json["location"] as? String ?? ""
                                    PointOfContact = json["poc"] as? String ?? ""
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else if let error = error {
                            // Handle the error
                        }
                    }
                       pointOfContact = ""
                        location = ""
                    } catch {
                    print(error.localizedDescription)
                    }
                    
                }label: {
                    // Button label
                    Text("Update your Profile")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green))
                        .padding(.horizontal)
                }
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Response"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
}

struct NavigationBarComedyClubView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarComedyClubView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
