//
//  NavigationBarComedyClubView.swift
//  MIC
//
//  Created by Sowri on 4/24/23.
//

import SwiftUI
import FirebaseAuth

struct NavigationBarComedyClubView: View {
    // MARK: - PROPERTIES
    @State private var isAnimated: Bool = false
    @AppStorage("uid") var userID: String = ""
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
               
            }, label:{
                ZStack {
                    Image(systemName: "person.circle")
                        .font(.title)
                    .foregroundColor(.black)
                }
            }) //: Button
        } //: HSTACK
    }
}

struct NavigationBarComedyClubView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarComedyClubView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
