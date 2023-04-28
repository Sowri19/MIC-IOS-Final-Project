//
//  SignUpView.swift
//  MIC
//
//  Created by Sowri on 4/18/23.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var picture: String = ""
    @State private var bookings = []
    @State private var Comedian = false
    @State private var ComedyClub = false
    
    
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
    @AppStorage("isComedian") var isComedian: Bool = false
    @AppStorage("isComedyClub") var isComedyClub: Bool = false
    @AppStorage("isDocumentID") var isDocumentID: String = ""
    
    private func isValidPassword(_ password: String) -> Bool{
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return passwordRegex.evaluate(with: password)
    }
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                HStack{
                    Text("Create an Account!")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding()
                .padding(.top)
                Spacer()
                HStack{
                    Image(systemName: "mail")
                    TextField("Email", text: $email )
                    Spacer()
                    if(email.count != 0){
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                HStack{
                    Image(systemName: "lock")
                    SecureField("Password", text: $password )
                    Spacer()
                    if(password.count != 0){
                        Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                HStack {
//                    Text("First Name: " + firstName)
                    TextField("Enter your first name", text: $firstName)
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                HStack {
//                    Text("Last Name: " + lastName)
                    TextField("Enter your last name", text: $lastName)
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                HStack{
                    Image(systemName: "person")
                    Toggle("Stand-up Comedian?", isOn: $Comedian)
                    Spacer()
                    if(Comedian){
                        Image(systemName: "checkmark")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }else{
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                
                HStack{
                    Image(systemName: "person")
                    Toggle("Comedy Club?", isOn: $ComedyClub)
                    Spacer()
                    if(ComedyClub){
                        Image(systemName: "checkmark")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }else{
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                }
                .foregroundColor(.white)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.white))
                .padding()
                
                Group {
                    Button(action: {
                        withAnimation{self.currentShowingView = "login"}
                    }){
                        Text("Already Have an account?")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Spacer()
                    Button{
                        // Check if email and password are not empty
                        guard !email.isEmpty, !password.isEmpty else {
                            // Show alert message
                            MIC.showAlert(title: "Error", message: "Please enter both email and password")
                            return
                        }
                        // Check if email is valid
                        guard email.isValidEmail() else {
                            // Show alert message
                            MIC.showAlert(title: "Error", message: "Please enter a valid email address")
                            return
                        }
                        // Check if password is valid
                        guard isValidPassword(password) else {
                            // Show alert message
                            MIC.showAlert(title: "Error", message: "Please enter a valid password (minimum 6 characters with at least one uppercase letter, one special character and one lowercase letter)")
                            return
                        }
                        // Check if both toggles are selected(Comedian and Comedy Club)
                        guard !(Comedian && ComedyClub) else {
                            // Show alert message
                            MIC.showAlert(title: "Error", message: "Please select only one option between Comedian and Comedy Club")
                            return
                        }

                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                print(error)
                                // Show alert message
                                MIC.showAlert(title: "Error", message: error.localizedDescription)
                                return
                            }
                            if let authResult = authResult {
                                let db = Firestore.firestore()
                                let docData: [String: Any] = ["isComedian": Comedian, "isComedyClub": ComedyClub, "firstName": firstName, "lastName": lastName, "picture": picture, "email": email, "uid": authResult.user.uid]

                                let docRef = db.collection("users").addDocument(data: docData) { error in
                                    if let error = error {
                                        // Show error message
                                        print("Error saving user data: \(error.localizedDescription)")
                                        MIC.showAlert(title: "Error", message: "Error saving user data")
                                    } else {
                                        print("User data saved successfully")
                                    }
                                }

                                docRef.getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        self.isDocumentID = document.documentID
                                        self.isComedian = document.data()?["isComedian"] as? Bool ?? false
                                        self.isComedyClub = document.data()?["isComedyClub"] as? Bool ?? false
                                        self.isDocumentID = document.data()?["isDocumentID"] as? String ?? isDocumentID
                                        
                                           print("Document ID: \(document.documentID)")
                                           print("isComedian: \(isComedian)")
                                           print("isComedyClub: \(isComedyClub)")
                                           print("isDocumentID: \(isDocumentID)")
                                        
                                        print("Document ID: \(document.documentID)")
                                    } else {
                                        print("Error retrieving document ID: \(error?.localizedDescription ?? "unknown error")")
                                    }
                                }

                                print(authResult.user.uid)
                                print(authResult.user.displayName ?? "")
                                userID = authResult.user.uid
                                
                            }

                        }
                    }label: {
                        // Button label
                        Text("Create New Account")
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

            }
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Response"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}



private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
}





