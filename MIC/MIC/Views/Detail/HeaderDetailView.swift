//
//  HeaderDetailView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI

struct HeaderDetailView: View {
    // MARK: - PROPERTY
    
    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            Text("Protective Gear")
            Text("test")
                .font(.largeTitle)
                .fontWeight(.black)
        }) //: VSTACK
        .foregroundColor(.white)
    }
}

struct HeaderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderDetailView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray)
    }
}
