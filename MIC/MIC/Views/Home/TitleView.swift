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
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                .padding(.horizontal, 20)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(title: "Comedian")
            .previewLayout(.sizeThatFits)
            .background(colorBackground)
    }
}
