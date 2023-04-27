//
//  Navigate.swift
//  MIC
//
//  Created by Sowri on 4/26/23.
//

import Foundation

class Navigate: ObservableObject {
    @Published var showingProfile: Bool = false
    @Published var selectedProfile: Comedian? = nil
}
