//
//  ComedyClubView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//


import SwiftUI
import FirebaseAuth
import Firebase
import UIKit

struct ComedyClubView: View {
    // MARK: - Property
    
    // MARK: - Body
//    @State private var firstName = ""
//    @State private var lastName = ""
//    @State private var location = ""
//    @State private var pointOfContact = ""
//    @State private var bio = ""
//    @State private var genre = ""
//    @State private var isComedyClub = false
//    @State private var picture: UIImage?
    // MARK: - Property
//        let comedyClub: ComedyClub
    var body: some View {
        
        
            
            // MARK: - Body
            
                Button(action: {}, label: {
                    HStack(alignment: .center, spacing: 6){
                        // Show the comedy club's picture
                        Image(uiImage: comedyClub.picture ?? UIImage(named: "defaultImage")!)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(.gray)
                        // Show the comedy club's first name
                        Text(comedyClub.firstName)
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                    } //: HStack
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                }) //: Button
           
//        Button(action: {}, label: {
//            HStack(alignment: .center, spacing: 6){
//                // Build an array of Image views for each comedy club's picture
//                let pictureViews = comedyClubs.map { comedyClub in
//                    Image(uiImage: comedyClub.picture ?? UIImage(named: "defaultImage")!)
//                        .renderingMode(.template)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30, alignment: .center)
//                        .foregroundColor(.gray)
//                }
//                // Combine the picture views and first name texts with spacers
//                ForEach(comedyClubs.indices, id: \.self) { index in
//                    if index > 0 {
//                        Spacer()
//                    }
//                    pictureViews[index]
//                    Text(comedyClubs[index].firstName)
//                        .fontWeight(.light)
//                        .foregroundColor(.gray)
//                    Spacer()
//                }
//            } //: HStack
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
//        }) //: Button

    }
}

struct ComedyClubView_Previews: PreviewProvider {
    static var previews: some View {
      ComedyClubView()

//        ComedyClubView(comedyClub: ComedyClub(firstName: firstName, lastName: lastName, location: location, pointOfContact: pointOfContact, bio: bio, genre: genre, isComedyClub: isComedyClub))
            .padding()
            .background(Color.gray)
    }
}
