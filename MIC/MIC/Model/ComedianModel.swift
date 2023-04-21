//
//  ComedianModel.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import Foundation
struct ComedianModel: Codable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let price: Int
    let description: String
    let color: [Double]
    
    var red: Double { return color[0]}
    var green: Double { return color[1]}
    var blue: Double { return color[2]}
    
    var formattedPrice: String {return "$\(price)"}
}
