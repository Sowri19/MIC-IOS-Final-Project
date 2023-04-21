//
//  ComedianView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI

struct ComedianView: View {
    // MARK: - PROPERTY
//    let comedian: Comedian
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 6, content: {
        // PHOTO
            ZStack {
                Image("appstore")
                    .resizable()
                    .scaledToFit()
                    .padding(10)
        } //: ZStack
//            .background(Color(red: ))
            .cornerRadius(12)
            
            //NAME
            Text("Comdedian")
                .font(.title3)
                .fontWeight(.black)
            //PRICE
            Text("Price")
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        })
    }
}

struct ComedianView_Previews: PreviewProvider {
    static var previews: some View {
        ComedianView()
            .previewLayout(.fixed(width: 200, height: 300))
            .padding()
            .background(colorBackground)
    }
}
