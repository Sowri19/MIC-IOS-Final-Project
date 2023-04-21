//
//  ContentView.swift
//  MIC
//
//  Created by Sowri on 4/18/23.
//

import SwiftUI
import FirebaseAuth
struct ContentView: View {
    @AppStorage("uid") var userID: String = ""
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                if userID == "" {
                    AuthView()
                } else {
                    NavigationBarView()
                        .padding(.horizontal, 15)
                        .padding(.bottom)
                        .padding(.top, UIApplication.shared.connectedScenes
                                .compactMap { $0 as? UIWindowScene }
                                .first?.windows.first?.safeAreaInsets.top ?? 0)
                        .background(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
//                    Text("Logged In! \nYour user id is \(userID)")
//                    Button(action: {
//                        let firebaseAuth = Auth.auth()
//                        do {
//                          try firebaseAuth.signOut()
//                            withAnimation{
//                                userID = ""
//                            }
//                        } catch let signOutError as NSError {
//                          print("Error signing out: %@", signOutError)
//                        }
//                    }){
//                        Text("Sign Out")
//                    }
                    ScrollView(.vertical, showsIndicators: false, content:{
                        VStack(spacing: 0){
                            FeaturedTabView()
                                .padding(.vertical, 20)
                            ComedyClubGridView()
                            TitleView(title: "Comedians")
                            LazyVGrid(columns: gridLayout, spacing: 15, content: {
//                                ForEach(<#T##data: Range<Int>##Range<Int>#>, content: <#T##(Int) -> View#>)
                                ComedianView()
                            }) //:Grid
                            .padding(15)
                            TitleView(title: "Comedy Categories")
                            ComedyCategoryGridView()
                             
                            FooterView()
                                .padding(.horizontal)
                        } //:VStack
                    }) //: SCROLL
                }
            } //: VSTACK
            .background(colorBackground.ignoresSafeArea(.all, edges: .all))
        } //: ZSTACK
        .ignoresSafeArea(.all, edges: .top)
    }
    // MARK: - <#placeholder#>

}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
