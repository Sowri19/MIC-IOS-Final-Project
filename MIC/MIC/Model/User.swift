//
//  User.swift
//  MIC
//
//  Created by Rikin Parekh on 4/22/23.
//

import Foundation

struct User: Encodable {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var id: Int
    var picture: String
    var bookings: [Booking]
    
    enum CodingKeys: String, CodingKey {
            case email
            case password
            case firstName = "first_name"
            case lastName = "last_name"
            case id
            case picture
            case bookings = "bookings"
        }
        
    struct Booking: Codable {
            var id: Int
            var event_id: Int
            var user_id: Int
        }
}
