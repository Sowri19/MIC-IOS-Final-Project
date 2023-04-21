//
//  FeaturedComedianView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import SwiftUI

struct FeaturedComedianView: View {
    // MARK: - PROPERTY
//    let player: Player
    // MARK: - BODY

    var body: some View {
        Image("appstore")
            .resizable()
            .scaledToFit()
            .cornerRadius(12)
    }
}

struct FeaturedComedianView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedComedianView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(colorBackground)
    }
}
