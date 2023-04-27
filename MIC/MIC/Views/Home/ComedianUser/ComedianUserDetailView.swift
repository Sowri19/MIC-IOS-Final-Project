//
//  ComedianUserDetailView.swift
//  MIC
//
//  Created by Sowri on 4/24/23.
//

import SwiftUI

struct ComedianUserDetailView: View {
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

struct ComedianUserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComedianUserDetailView(title: "Your Events")
            .previewLayout(.sizeThatFits)
            .background(colorBackground)
    }
}
