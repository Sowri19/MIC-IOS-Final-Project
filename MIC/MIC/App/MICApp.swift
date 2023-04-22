//
//  MICApp.swift
//  MIC
//
//  Created by Sowri on 4/18/23.
//

import SwiftUI
import FirebaseCore

@main
struct MICApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
