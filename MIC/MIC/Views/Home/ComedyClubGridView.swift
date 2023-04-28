//
//  ComedyGridView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import SwiftUI
import Firebase

struct ComedyClubGridView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var location = ""
    @State private var pointOfContact = ""
    @State private var bio = ""
    @State private var genre = ""
    @State private var isComedyClub = false
    @State private var picture: UIImage?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHGrid(rows: gridLayout, alignment: .center, spacing: columnSpacing, pinnedViews: [], content: {
                
                Section(
                    header: SectionView(rotateClockwise: false),
                    footer: SectionView(rotateClockwise: true))
                {
                    ForEach(comedyClubs, id: \.id) { comedyClub in
//                        ComedyClubView(comedyClub: comedyClub)
                    }

//                    Text("placeholder")
//                    Text("placeholder")
//                    Text("placeholder")
//                    Text("placeholder")
//                    Text("placeholder")
//                    Text("placeholder")
//                    Text("placeholder")
//                    Text("placeholder")
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
