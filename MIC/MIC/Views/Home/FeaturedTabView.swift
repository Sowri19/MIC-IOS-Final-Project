//
//  FeaturedTabView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import SwiftUI

struct FeaturedTabView: View {
    var body: some View {
        TabView {
//            ForEach(players) { player in
//                FeaturedTabView(player: player)
//            }
            FeaturedComedianView()
                .padding(.top, 10)
                .padding(.horizontal, 15)
        } //:TAB
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct FeaturedTabView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedTabView()
            .previewDevice("iphone 14 pro")
            .background(Color.gray)
    }
}
