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
    
    
    
    @State private var showAlert = false
    @State private var alertMessage = ""

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
                        
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let error = error {
                                print(error)
                                // Show alert message
                                MIC.showAlert(title: "Error", message: error.localizedDescription)
                                return
                            }
                            if let authResult = authResult {
                                let db = Firestore.firestore()
                                db.collection("users").addDocument(data: ["isComedian": Comedian, "uid": authResult.user.uid]) { error in
                                    if let error = error {
                                        // Show error message
                                        print("Error saving user data: \(error.localizedDescription)")
                                        MIC.showAlert(title: "Error", message: "Error saving user data")
                                    } else {
                                        print("User data saved successfully")
                                    }
                                }
                                print(authResult.user.uid)
                                print(authResult.user.displayName ?? "")
                                userID = authResult.user.uid
                                
                                
                                let user = User(email: email, password: password, firstName: firstName, lastName: lastName, id: Int(userID) ?? 0, picture: "profile.jpg", bookings: [])
                                
                                do {
                                    
                                    let body = [
                                        "id": userID,
                                        "email": email,
                                        "password": password,
                                        "firstName": firstName,
                                        "lastName": lastName,
                                        "picture": user.picture
                                    ]
                                    let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                                    let jsonString = String(data: jsonData, encoding: .utf8)!
                                    print(jsonString)
//                                    var jsonData = try JSONEncoder().encode(user)
//                                    var jsonString = String(data: jsonData, encoding: .utf8)
//                                    var jsonString = "userId=300&title=My urgent task&completed=false"
//                                    let jsonNode = try objectMapper.readTree(data: data)
                                    sendRequest(jsonString)
                                } catch {
                                    print(error.localizedDescription)
                                }
                                
                            }
                            
                            
                            func sendRequest(_ payload: String?) {
                                guard let url = URL(string: "http://localhost:8080/users/create") else {
                                    return
                                }
                                
                                var request = URLRequest(url: url)
                                request.httpMethod = "POST"
                                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                
                                request.httpBody = payload?.data(using: .utf8)
//                                request.httpBody = components.query?.data(using: .utf8)
//                                request.httpBody = payload
                                
//                                request.httpBody = try? JSONSerialization.data(withJSONObject: jsonString)
                                
                                
                                
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





