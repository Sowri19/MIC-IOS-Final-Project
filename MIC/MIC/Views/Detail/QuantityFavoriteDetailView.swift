//
//  QuantityFavoriteDetailView.swift
//  MIC
//
//  Created by Sowri on 4/25/23.
//

import SwiftUI

struct QuantityFavoriteDetailView: View {
    // MARK: - PROPERTY
    @State private var counter: Int = 0
    // MARK: - BODY
    
    var body: some View {
        HStack(alignment: .center, spacing: 6, content: {
            Button(action: {
                if counter > 0 {
                    counter -= 1
                }
            }, label: {
                Image(systemName: "minus.circle")
            })
            Text("\(counter)")
                .fontWeight(.semibold)
                .frame(minWidth: 36)
            Button(action: {
                if counter < 100 {
                    counter += 1 
                }
            }, label: {
                Image(systemName: "plus.circle")
            })
            Spacer()
            Button(action: {}, label: {
                Image(systemName: "heart.circle")
                    .foregroundColor(.pink)
                    
            })
        }) //: HSTACK
    }
}

struct QuantityFavoriteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QuantityFavoriteDetailView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
