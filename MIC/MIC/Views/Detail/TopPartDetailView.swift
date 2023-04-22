//
//  TopPartDetailView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI
// MARK: - PROPERTY

// MARK: - BODY

struct TopPartDetailView: View {
    
    // MARK: - Property
    @State private var isAnimating: Bool = false
    // MARK: - BODY

    var body: some View {
        HStack(alignment: .center, spacing: 6, content: {
            // PRICE
            VStack(alignment: .leading, content: {
                Text("placeholder")
                    .fontWeight(.semibold)
                    .fontWeight(.black)
                    .scaleEffect(1.35, anchor: .leading)
            }) //: VSTACK
            .offset(y: isAnimating ? -50 : -75)
            Spacer()
            
           // PHOTO
            Image("appstore")
                .resizable()
                .scaledToFit()
                .offset(y: isAnimating ? 0 : -35)
        }) //: HSTACK
        .onAppear(perform: {
            withAnimation(.easeOut(duration:  0.75)) {
                isAnimating.toggle()
            }
        })
    }
}

struct TopPartDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TopPartDetailView()
            .previewLayout(.sizeThatFits)
            .padding()
            
    }
}
