//
//  FooterView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            Text("we offer the most popular standup comedy shows in and around you")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .layoutPriority(2)
            Image("")
                .renderingMode(.template)
                .foregroundColor(.gray)
                .layoutPriority(0)
            Text("© Copyright MIC\nAll Rights Reserved")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .layoutPriority(1)
        }
        .padding()
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView()
            .previewLayout(.sizeThatFits)
            .background(colorBackground)
    }
}
