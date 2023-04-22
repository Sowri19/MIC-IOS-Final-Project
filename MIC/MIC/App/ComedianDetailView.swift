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
            NavigationBarDetailView()
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
            // DETAIL BOTTOM PART
            // RATING +SIZES
            // DESCRIPTION
            // QUANTITY + FAVORITE
            // ADD TO CART
            Spacer()
        }) //: VSTACK
        .ignoresSafeArea(.all, edges: .all)
//        .background().ignoreSafeArea(.all, edges: .all)
        
    }
}

struct ComedianDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComedianDetailView()
            .previewLayout(.fixed(width: 375, height: 812))
    }
}
