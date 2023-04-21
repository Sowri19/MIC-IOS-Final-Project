//
//  ComedyCategoryView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI

struct ComedyCategoryView: View {
    // MARK: - Property
//    let brand: Brand
    
    var body: some View {
        Image("appstore")
            .resizable()
            .scaledToFit()
            .padding()
            .background(Color.white.cornerRadius(12))
            .background(
                RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
    }
}

struct ComedyCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ComedyCategoryView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(colorBackground)
    }
}
