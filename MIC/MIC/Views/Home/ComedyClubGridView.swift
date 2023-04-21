//
//  ComedyGridView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import SwiftUI

struct ComedyClubGridView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHGrid(rows: gridLayout, alignment: .center, spacing: columnSpacing, pinnedViews: [], content: {
//                Image("appstore")
//                Image("appstore")
//                Image("appstore")
//                Image("appstore")
//                Image("appstore")
//                Image("appstore")
//                Image("appstore")
                
                Section(
                    header: SectionView(rotateClockwise: false),
                    footer: SectionView(rotateClockwise: true))
                {
//                ForEach(categories){
//                category in ComedyClubView(category: category)
//                }
                    Text("placeholder")
                    Text("placeholder")
                    Text("placeholder")
                    Text("placeholder")
                    Text("placeholder")
                    Text("placeholder")
                    Text("placeholder")
                    Text("placeholder")
            }
            })// : GRID
            .frame(height: 140)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }) //: SCROLL
    }
}

struct ComedyClubGridView_Previews: PreviewProvider {
    static var previews: some View {
        ComedyClubGridView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(colorBackground)
    }
}
