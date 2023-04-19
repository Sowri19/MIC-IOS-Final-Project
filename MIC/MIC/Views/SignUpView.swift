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
    @State private var Comedian = false

    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
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
                        showAlert(title: "Error", message: "Please enter both email and password")
                        return
                    }
                    // Check if email is valid
                    guard email.isValidEmail() else {
                        // Show alert message
                        showAlert(title: "Error", message: "Please enter a valid email address")
                        return
                    }
                    // Check if password is valid
                    guard isValidPassword(password) else {
                        // Show alert message
                        showAlert(title: "Error", message: "Please enter a valid password (minimum 6 characters with at least one uppercase letter, one special character and one lowercase letter)")
                        return
                    }
                    
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            // Show alert message
                            showAlert(title: "Error", message: error.localizedDescription)
                            return
                        }
                        if let authResult = authResult {
                            let db = Firestore.firestore()
                            db.collection("users").addDocument(data: ["isComedian": Comedian, "uid": authResult.user.uid]) { error in
                                if let error = error {
                                    // Show error message
                                    print("Error saving user data: \(error.localizedDescription)")
                                    showAlert(title: "Error", message: "Error saving user data")
                                } else {
                                    print("User data saved successfully")
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


