//
//  ComedyCategoryGridView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI

struct ComedyCategoryGridView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHGrid(rows: gridLayout, spacing: columnSpacing, content: {
                Text("Placeholder")
                Text("Placeholder")
            }) //: GRID
            .frame(height: 200)
            .padding(15)
        }) //: SCROLL
    }
}

struct ComedyCategoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        ComedyCategoryGridView()
            .previewLayout(.sizeThatFits)
            .background(colorBackground)
    }
}
