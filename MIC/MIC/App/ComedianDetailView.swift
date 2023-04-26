//
//  ComedianDetailView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI

struct ComedianDetailView: View {
    // MARK: - PROPERTY
    
    // MARK: - BODY

    var body: some View {

        VStack(alignment: .leading, spacing: 5, content: {
            // NAVBAR
            NavigationBarComedianDetailView()
                .padding(.horizontal)
                .padding(.top, UIApplication.shared.connectedScenes
                        .compactMap { $0 as? UIWindowScene }
                        .first?.windows.first?.safeAreaInsets.top ?? 0)
            // HEADER
            Text("details")
            HeaderDetailView()
                .padding(.horizontal)
            // DETAIL TOP PART
            TopPartDetailView()
                .padding(.horizontal)
                .zIndex(1)
            // DETAIL BOTTOM PART
            VStack(alignment: .center, spacing: 0, content: {
                // RATING +SIZES
                RatingsSizesDetailView()
                    .padding(.top, -20)
                    .padding(.bottom, 10)
                 
                // DESCRIPTION
                ScrollView(.vertical, showsIndicators: false, content: {
                    Text("sampleproductsampleproductsampleproductsampleproductsampleproductsampleproductsampleproductsampleproductsampleproductsampleproductsampleproductsampleproduct")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                })
                // QUANTITY + FAVORITE
                QuantityFavoriteDetailView()
                    .padding(.vertical, 10)
                // ADD TO CART
                AddToCartDetailView()
                    .padding(.bottom, 20)
            }) //: VSTACK
            .padding(.horizontal)
            .background(
                Color.white
                    .clipShape(CustomShape())
                    .padding(.top, -105)
            )
        }) //: VSTACK
        .zIndex(0)
        .ignoresSafeArea(.all, edges: .all)
//        .background().ignoreSafeArea(.all, edges: .all).ignoresSafeArea(.all, edges: .all)
        
    }
}

struct ComedianDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComedianDetailView()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}
