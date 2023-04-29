//
//  NavigationBarView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import SwiftUI
import FirebaseAuth
import Firebase
import UIKit


struct UserImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UserImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<UserImagePicker>) {
        
    }
    
    func makeCoordinator() -> UserImagePicker.Coordinator {
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

struct NavigationBarView: View {
    // MARK: - PROPERTIES
    @AppStorage("uid") var userID: String = ""
    @State private var isAnimated: Bool = false
    @State private var showProfileView: Bool = false // New state variable
    @AppStorage("isDocumentID") var isDocumentID: String = ""
    
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
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.red)
                    .cornerRadius(10)
                    .frame(width: 90, height: 30)
            }
            Button(action: {
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
            UserProfileView()
        }
    }
    
}

struct UserProfileView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var picture: UIImage?
    @State private var email: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    @AppStorage("uid") var userID: String = ""
    @AppStorage("isDocumentID") var isDocumentID: String = ""
    

    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
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
                .onAppear(){
                    let db = Firestore.firestore()
                    db.collection("users").document(isDocumentID).getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.firstName = document.data()?["firstName"] as? String ?? ""
                            self.lastName = document.data()?["lastName"] as? String ?? ""
                            self.email = document.data()?["email"] as? String ?? ""
                            if let imageData = document.data()?["picture"] as? Data {
                                self.selectedImage = UIImage(data: imageData)
                            }
                            print("Document ID: \(document.documentID)")
                        } else {
                            print("Error retrieving document ID: \(error?.localizedDescription ?? "unknown error")")
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
                        
                        Text("Your Email:")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextEditor(text: $email)
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
                    let db = Firestore.firestore()
                    let documentRef = db.collection("users").document(isDocumentID)
                    let imageData = selectedImage?.jpegData(compressionQuality: 0.5)
                    documentRef.setData([
                        "picture": imageData ?? Data()
                    ], merge: true) { err in
                        if let err = err {
                            print("Error appending data: \(err)")
                        } else {
                            print("Data appended successfully!")
                        }
                    }
                    selectedImage = nil
                  
                    db.collection("users").document(isDocumentID).getDocument { (document, error) in
                        if let document = document, document.exists {
                            if let imageData = document.data()?["picture"] as? Data {
                                self.selectedImage = UIImage(data: imageData)
                            }
                            print("Document ID: \(document.documentID)")
                        } else {
                            print("Error retrieving document ID: \(error?.localizedDescription ?? "unknown error")")
                        }
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

// MARK: - PREVIEW

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
