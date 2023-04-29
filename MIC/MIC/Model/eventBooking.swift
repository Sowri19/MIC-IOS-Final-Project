//
//  eventBooking.swift
//  MIC
//
//  Created by Sowri on 4/29/23.
//

import Foundation

struct EventBooking: Identifiable, Hashable {
    var id = UUID()
    var eventID: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
