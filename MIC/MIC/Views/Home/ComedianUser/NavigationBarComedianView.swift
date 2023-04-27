//
//  NavigationBarViewCC.swift
//  MIC
//
//  Created by Sowri on 4/24/23.
//

import SwiftUI
import FirebaseAuth
import Firebase
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
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
struct NavigationBarComedianView: View {
    // MARK: - PROPERTIES
        @State private var firstName: String = ""
        @State private var lastName: String = ""
        @State private var Genre: String = ""
        @State var bio: String = ""
    @AppStorage("uid") var userID: String = ""
    @State private var isAnimated: Bool = false
    @State private var showProfileView: Bool = false // New state variable

    // MARK: - BODY
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
                fetchUserData { (data, error) in
                    if let data = data?.data(using: .utf8) {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                firstName = json["firstName"] as? String ?? ""
                                lastName = json["lastName"] as? String ?? ""
                                Genre = json["genre"] as? String ?? ""
                                bio = json["bio"] as? String ?? ""
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else if let error = error {
                        // Handle the error
                    }
                }
                            showProfileView = true // Set the state variable to true to show the view
                
                        }, label:{
                            ZStack {
                                Image(systemName: "person.circle")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                        }) //: Button
                    }
                    .sheet(isPresented: $showProfileView) {
                        // Present the ProfileView modally
                        ProfileView(firstName: $firstName, lastName: $lastName, Genre: $Genre, bio: $bio)
                    }
                }
            }

struct ProfileView: View {
    
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var Genre: String
    @Binding var bio: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var getResponse = [String: Any]()
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State var userData = [String: Any]()
    
    @AppStorage("uid") var userID: String = ""
    @AppStorage("isComedian") var isComedian: Bool = false
    @AppStorage("isComedyClub") var isComedyClub: Bool = false
    @AppStorage("isDocumentID") var isDocumentID: String = ""
    @AppStorage("profileImage") var profileImage: String = ""
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                HStack{
                    Text("Welcome \(firstName)!!\nYour Profile")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                VStack{
                    //  Fetched Comedian View from the database
                    ScrollView(.vertical, showsIndicators: true, content:{
                        VStack{
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
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]) {
                                Text("First Name:")
                                    .font(.headline)
                                TextField("Enter First Name", text: $firstName)
                                Text("Last Name:")
                                    .font(.headline)
                                TextField("Enter Last Name", text: $lastName)
                                Text("Your Genre:")
                                    .font(.headline)
                                TextField("Your Genre", text: $Genre)
                                Text("Your Bio:")
                                    .font(.headline)
                                TextField("Bio", text: $bio)
                            }
                        }
                        .padding()
                    })
                }

                HStack {
                    //                    Text("First Name: " + firstName)
                    Image(systemName: "pencil.and.outline")
                    TextField("Write your Bio", text: $bio)
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                
                HStack {

                    Image(systemName: "list.bullet.clipboard")
                    TextField("What is your Genre", text: $Genre)
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
                    
                    let compressionQuality: CGFloat = 0.1
                    let imageData = selectedImage?.jpegData(compressionQuality: compressionQuality)
                    
                    let base64ImageString = imageData?.base64EncodedString(options: .lineLength64Characters)
                    
                    do {
                        let body = [
                            "id": userID,
                            //                            "picture": base64ImageString ?? "",
                            "genre": Genre,
                            "bio": bio
                        ] as [String : Any]
                        let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                        let jsonString = String(data: jsonData, encoding: .utf8)!
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


struct NavigationBarComedianView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarComedianView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
