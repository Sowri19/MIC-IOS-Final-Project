//
//  TitleView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI

struct TitleView: View {
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

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(title: "Comedian")
            .previewLayout(.sizeThatFits)
            .background(colorBackground)
    }
}
