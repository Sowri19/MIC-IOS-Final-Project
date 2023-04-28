//
//  ComedyClubModel.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import Foundation

import Firebase

//struct ComedyClubModel: Codable, Identifiable {
//    let id: Int
//    let name: String
//    let image: String
//}
struct ComedyClub: Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var location: String
    var pointOfContact: String
    var bio: String
    var genre: String
    var isComedyClub: Bool
    var picture: UIImage?
}
var comedyClubs = [ComedyClub]()

func fetchComedyClubs() {
    let db = Firestore.firestore()
    db.collection("users").whereField("isComedyClub", isEqualTo: true).getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error retrieving documents: \(error.localizedDescription)")
            return
        }
        for document in querySnapshot!.documents {
            let firstName = document.data()["firstName"] as? String ?? ""
            let lastName = document.data()["lastName"] as? String ?? ""
            let location = document.data()["location"] as? String ?? ""
            let pointOfContact = document.data()["pointOfContact"] as? String ?? ""
            let bio = document.data()["bio"] as? String ?? ""
            let genre = document.data()["genre"] as? String ?? ""
            let isComedyClub = document.data()["isComedyClub"] as? Bool ?? false
            var picture: UIImage?
            if let imageData = document.data()["picture"] as? Data {
                picture = UIImage(data: imageData)
            }
            let comedyClub = ComedyClub(firstName: firstName, lastName: lastName, location: location, pointOfContact: pointOfContact, bio: bio, genre: genre, isComedyClub: isComedyClub, picture: picture)
            comedyClubs.append(comedyClub)
        }
        // Use the comedyClubs array here, once it's populated with data from Firebase
    }
}

