//
//  EventMode.swift
//  MIC
//
//  Created by Sowri on 4/28/23.
//
import Foundation
import UIKit

struct Event: Identifiable, Hashable {
    let id: String
    let comedianID: String
    let comedianName: String
    let comedyClubID: String
    let date: String
    let description: String
    let eventName: String
    let picture: UIImage?
    let price: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
