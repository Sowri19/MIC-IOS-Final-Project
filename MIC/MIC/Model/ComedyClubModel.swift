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
struct ComedyClub: Identifiable, Hashable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var location: String
    var pointOfContact: String
    var bio: String
    var genre: String
    var isComedyClub: Bool
    var picture: UIImage?
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
}
//var comedyClubs = [ComedyClub]()
//
//func fetchComedyClubs() {
//    }


