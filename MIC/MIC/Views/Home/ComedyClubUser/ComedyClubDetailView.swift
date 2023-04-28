//
//  ComedyClubDetailView.swift
//  MIC
//
//  Created by Sowri on 4/24/23.
//

import SwiftUI

struct ComedyClubDetailView: View {
    // MARK: - PREVIEW
    
    var title: String
    
    
    // MARK: - BODY

    var body: some View {
        HStack{
            Text(title)
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Spacer()
        }
    }
}

struct ComedyClubDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComedyClubDetailView(title: "Your Events")
            .previewLayout(.sizeThatFits)
            .background(colorBackground)
            .preferredColorScheme(.dark)
    }
}
